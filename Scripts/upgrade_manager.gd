class_name UpgradeManager

extends Node
@onready var ui: MainUI = $'../UI'
@onready var level: Level = get_parent() as Level

@export var upgrades: Array[UpgradeItemInfo]

var randomUpgrades: Dictionary[int, UpgradeItemInfo] = {}
var upgradesTaken: Dictionary[UpgradeItemInfo, int] = {}
var currentUpgradeUI: Dictionary[UpgradeItemInfo, UpgradeUI] = {}


func _ready() -> void:
	level.player_spawned.connect(_on_player_spawned)

func _on_player_spawned(p: Player) -> void:
	p.stats_component.leveled_up.connect(_on_level_up)

func _on_level_up(_newLevel: int) -> void:
	randomUpgrades = {}
	for i in range(3):
		var randomIndex := randi_range(0, upgrades.size() - 1)
		var keys := randomUpgrades.keys()
		print(keys.find(randomIndex))
		while keys.find(randomIndex) != -1:
			randomIndex = randi_range(0, upgrades.size() - 1)
		
		var upgrade := upgrades[randomIndex]
		randomUpgrades[randomIndex] = upgrade

	ui.level_up_overlay.show_options(randomUpgrades)
	if !ui.level_up_overlay.on_button_pressed.is_connected(_on_level_up_option_chosen):
		ui.level_up_overlay.on_button_pressed.connect(_on_level_up_option_chosen)

func _on_level_up_option_chosen(option: int) -> void:
	var chosenUpgrade := randomUpgrades[option]
	var stats := level.player.stats_component.stats

	if upgradesTaken.has(chosenUpgrade):
		upgradesTaken[chosenUpgrade] += 1
		currentUpgradeUI[chosenUpgrade].num.text = "x" + str(upgradesTaken[chosenUpgrade])
	else:
		upgradesTaken[chosenUpgrade] = 1
		var upgradeUI := ui.upgradePrefab.instantiate() as UpgradeUI
		ui.upgrades_container.add_child(upgradeUI)
		upgradeUI.texture.texture = chosenUpgrade.sprite
		currentUpgradeUI[chosenUpgrade] = upgradeUI

	if chosenUpgrade.overtimeEffect != null:
		print("Giving Overtime Effect")
		var newEffect : OverTimeEffect = chosenUpgrade.overtimeEffect.duplicate()
		if newEffect.effectType == newEffect.effect_types.BLEED:
			newEffect.value = level.player.stats_component.stats.damage * 0.25
		elif newEffect.effectType == newEffect.effect_types.POISON:
			newEffect.value = level.player.stats_component.stats.damage * 0.1
		level.player.overtimeEffects.append(newEffect)
	elif chosenUpgrade.instantEffect != null:
		print("Giving Instant Effect")
		var newEffect : InstantEffect = chosenUpgrade.instantEffect.duplicate()
		if newEffect.effectType == newEffect.effect_types.LIFESTEAL:
			newEffect.value = level.player.stats_component.stats.damage * 0.2
		level.player.instantEffects.append(newEffect)
		pass
	var int_modifiers: Dictionary = {
		"attackRangeModifier": ["attackRange"],
		"attackSpeedModifier": ["attackSpeed"],
	}
	var float_modifiers: Dictionary = {
		"maxHpModifier": ["maxHp", "hp"],
		"hpModifier": ["hp"],
		"damageModifier": ["damage"],
		"attackCooldownModifier": ["attackCooldown"],
		"speedModifier": ["speed"],
	}

	for modifier_name: String in int_modifiers:
		var val: float = chosenUpgrade.get(modifier_name)
		if val > 0:
			for stat_name: String in int_modifiers[modifier_name]:
				var before: int = stats.get(stat_name)
				stats.set(stat_name, before + roundi(before * val))
				if stat_name == 'attackRange':
					level.player.attack_range_changed(stats.get(stat_name))

	for modifier_name: String in float_modifiers:
		if modifier_name == 'damageModifier':
			for effect in level.player.overtimeEffects:
				if effect.effectType == effect.effect_types.BLEED:
					effect.value = level.player.stats_component.stats.damage * 0.25
				elif effect.effectType == effect.effect_types.POISON:
					effect.value = level.player.stats_component.stats.damage * 0.1
		var val: float = chosenUpgrade.get(modifier_name)
		if val > 0:
			for stat_name: String in float_modifiers[modifier_name]:
				var before: float = stats.get(stat_name)
				stats.set(stat_name, before + before * val)
				var after: float = stats.get(stat_name)
				if stat_name == "hp":
					level.player.stats_component.hp_changed.emit(after)
		elif val < 0:
			for stat_name: String in float_modifiers[modifier_name]:
				var before: float = stats.get(stat_name)
				stats.set(stat_name, abs(before * val))
				if stat_name == 'attackCooldown':
					level.player.edit_attack_cooldown(stats.get(stat_name))