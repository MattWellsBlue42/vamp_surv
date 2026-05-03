class_name Main

extends Node

@onready var ui: Control = $UI
@onready var world: Node2D = $World

@export var level1: PackedScene
@export var gameOver: PackedScene
@export var mainMenu: PackedScene

var level: Level
var gameOverUI: GameOver
var currentMainMenu: MainMenu

func toggle_main_menu(active: bool) -> void:
	if active == true:
		if level:
			level.queue_free()
		currentMainMenu = mainMenu.instantiate()
		currentMainMenu.level_chosen.connect(go_to_level)
		ui.add_child(currentMainMenu)
	else:
		if !currentMainMenu:
			return
		currentMainMenu.queue_free()
		currentMainMenu = null

func _ready() -> void:
	print("Main Ready")
	toggle_main_menu(true)

func go_to_level(_level: int) -> void:
	toggle_main_menu(false)
	level = level1.instantiate() as Level
	level.player_spawned.connect(_on_player_spawn)
	world.add_child(level)

func _on_player_spawn(_player: Player) -> void:
	level.player.stats_component.died.connect(_on_player_death)

func _on_player_death() -> void:
	if gameOverUI:
		return
		
	Engine.time_scale = 0.5
	gameOverUI = gameOver.instantiate() as GameOver
	level.ui.add_child(gameOverUI)
	gameOverUI.youSurvivedLabel.text = "You survived: " + level.surviveTimeNiceString
	gameOverUI.back_to_main_menu.connect(_on_main_menu_chosen)
	gameOverUI.retry.connect(_on_level_retry)

func _on_level_retry(retryLevel: int) -> void:
	Engine.time_scale = 1
	level.queue_free()
	level = null
	go_to_level(retryLevel)

func _on_main_menu_chosen() -> void:
	Engine.time_scale = 1
	gameOverUI.queue_free()
	gameOverUI = null
	toggle_main_menu(true)
