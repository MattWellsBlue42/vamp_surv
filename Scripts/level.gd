class_name Level

extends Node2D

@onready var ui: MainUI = $UI

var surviveTime := 0.0
var surviveTimeNiceString: String

@export var playerPrefab: PackedScene
signal player_spawned(player: Player)
var player: Player
var playerAlive := true

func _process(delta: float) -> void:
	if !playerAlive:
		return
	surviveTime += delta
	var minutes: int = floori(surviveTime / 60.0)
	var seconds: int = int(surviveTime) % 60
	surviveTimeNiceString = "%02d:%02d" % [minutes, seconds]
	ui.timerLabel.text = surviveTimeNiceString

func spawn_player() -> void:
	player = playerPrefab.instantiate()
	add_child(player)
	player_spawned.emit(player)

func _ready() -> void:
	spawn_player()
	player.stats_component.died.connect(_on_player_death)
	var difficulty_timer := Timer.new()
	difficulty_timer.wait_time = 30.0
	difficulty_timer.timeout.connect(_on_difficulty_tick)
	add_child(difficulty_timer)
	difficulty_timer.start()

func _on_difficulty_tick() -> void:
	for spawner in get_tree().get_nodes_in_group("spawner"):
		var s := spawner as EnemySpawner
		s.spawnDelay = max(0.3, s.spawnDelay * 0.75)
		s.timer.wait_time = s.spawnDelay

func _on_player_death() -> void:
	playerAlive = false