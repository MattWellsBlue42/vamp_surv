class_name MainUI

extends CanvasLayer

@onready var player_status: Control = $PlayerStatus
@onready var level_up_overlay: LevelUpOverlay = $LevelUpOverlay
@onready var label: Label = $LevelUpOverlay/Label
@onready var level: Level = get_parent() as Level
@onready var timerLabel: Label = $MarginContainer/TimerLabel
@onready var upgrades_container: HBoxContainer = %UpgradesContainer
@onready var levelLabel: Label = %Level
@onready var progress: Label = %Progress
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var panel: Panel = $MarginContainer/VBoxContainer/MarginContainer/Panel

@export var upgradePrefab: PackedScene

var player: Player
var health_bar: ProgressBar

func toggle_status_ui(active: bool) -> void:
	player_status.visible = active

func toggle_level_up_overlay(active: bool, newLevel: int) -> void:
	level_up_overlay.visible = active
	label.text = "You leveled up to level: " + str(newLevel)

func trigger_level_up_ui(active: bool, newLevel: int) -> void:
	get_tree().paused = active
	toggle_status_ui(!active)
	toggle_level_up_overlay(active, newLevel)

func _ready() -> void:
	health_bar = player_status.get_child(0)
	level_up_overlay.on_button_pressed.connect(_on_level_up_option_chosen)
	level.player_spawned.connect(_on_player_spawned)

func _on_player_spawned(p: Player) -> void:
	player = p
	var statsComponent := player.stats_component
	health_bar.max_value = statsComponent.stats.maxHp
	statsComponent.hp_changed.connect(_on_hp_changed)
	statsComponent.leveled_up.connect(_on_leveled_up)
	statsComponent.gained_xp.connect(_on_player_gained_xp)

func _on_player_gained_xp(newXP: int) -> void:
	var statsComponent := player.stats_component
	progress_bar.max_value = statsComponent.nextLevel
	progress_bar.value = statsComponent.xp
	progress.text = str(newXP) + '/' + str(statsComponent.nextLevel)

func _on_level_up_option_chosen(_option: int) -> void:
	trigger_level_up_ui(false, 0)


func _on_hp_changed(newHp: float) -> void:
	health_bar.value = newHp

func _on_leveled_up(newLevel: int) -> void:
	print("Leveled up")
	trigger_level_up_ui(true, newLevel)
	levelLabel.text = "Level " + str(newLevel)
	var statsComponent := player.stats_component
	progress_bar.max_value = statsComponent.nextLevel
	progress_bar.value = statsComponent.xp
	progress.text = str(statsComponent.xp) + '/' + str(statsComponent.nextLevel)
	pass

func _process(_delta: float) -> void:
	if player == null or player.timer.wait_time == 0:
		return
	var ratio := player.timer.time_left / player.timer.wait_time
	panel.pivot_offset = Vector2(panel.size.x * 0.5, panel.size.y)
	panel.scale.y = ratio
