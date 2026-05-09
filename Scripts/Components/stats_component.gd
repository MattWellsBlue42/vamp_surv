class_name StatsComponent

extends Node

class ActiveEffect:
	var effect: OverTimeEffect
	var time_since_last_tick: float = 0.0
	var time_elapsed: float = 0.0

@export var stats: CharacterStats
@export var sprite: Sprite2D

var activeOvertimeEffects: Array[ActiveEffect]

var xp := 0
var nextLevel := 100
var level := 1

var godMode := false

func _process(_delta: float) -> void:
	if activeOvertimeEffects.size() > 0:
		var expired: Array[ActiveEffect] = []
		for activeEffect in activeOvertimeEffects:
			activeEffect.time_since_last_tick += _delta
			activeEffect.time_elapsed += _delta
			if activeEffect.time_since_last_tick >= activeEffect.effect.tickRate:
				print("Applying Overtime Effect: " + str(activeEffect.effect.value))
				take_damage(activeEffect.effect.value, [] as Array[OverTimeEffect], [] as Array[InstantEffect])
				activeEffect.time_since_last_tick = 0.0
			if activeEffect.time_elapsed >= activeEffect.effect.duration:
				expired.append(activeEffect)

		for toErase in expired:
			activeOvertimeEffects.erase(toErase)

func _ready() -> void:
	stats = stats.duplicate()
	stats.hp = stats.maxHp

#region XP Functions
signal leveled_up(newLevel: int)
signal gained_xp(newXP: int)

func level_up() -> void:
	level += 1
	nextLevel = roundi(nextLevel * 1.5)
	leveled_up.emit(level)

func increase_xp(amount: int) -> void:
	var newXP := xp + amount
	if newXP >= nextLevel:
		xp = newXP - nextLevel
		level_up()
	else:
		xp = newXP
	gained_xp.emit(xp)
#endregion

#region HP Functions
signal hp_changed(newHp: float)
signal died()

func take_damage(amount: float, overtimeEffects: Array[OverTimeEffect], instantEffects: Array[InstantEffect], damageSourceStatsComp: StatsComponent = null) -> void:
	if godMode:
		pass

	var newHp := float(clamp(stats.hp - amount, 0.0, stats.maxHp))
	if newHp <= 0.0:
		die()
		return
	stats.hp = newHp
	hp_changed.emit(newHp)
	sprite.modulate = Color.RED
	var tween := create_tween()
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.15)

	if overtimeEffects.size() > 0:
		for overtimeEffect in overtimeEffects:
			var activeAffect: ActiveEffect = ActiveEffect.new()
			activeAffect.effect = overtimeEffect.duplicate()
			activeOvertimeEffects.append(activeAffect)
	if instantEffects.size() > 0:
		for instantEffect in instantEffects:
			if instantEffect.effectType == instantEffect.effect_types.LIFESTEAL:
				var lifestealAmount: float = instantEffect.value
				if damageSourceStatsComp:
					var healedHp := clamp(damageSourceStatsComp.stats.hp + lifestealAmount, 0.0, damageSourceStatsComp.stats.maxHp) as float
					damageSourceStatsComp.stats.hp = healedHp
					damageSourceStatsComp.hp_changed.emit(healedHp)

func die() -> void:
	if godMode:
		pass

	stats.hp = 0
	hp_changed.emit(0.0)
	died.emit()
#endregion