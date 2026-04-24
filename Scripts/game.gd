extends Node

var playerPrefab: PackedScene = preload("res://Scenes/player.tscn")
@export var DEBUG_MODE := true

var player: Player

func spawn_player() -> void:
	player = playerPrefab.instantiate()
	get_parent().add_child.call_deferred(player)

func _ready() -> void:
	spawn_player()
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

func _process(_delta: float) -> void:
	pass
