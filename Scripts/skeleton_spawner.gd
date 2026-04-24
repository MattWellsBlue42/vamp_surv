class_name EnemySpawner

extends Node

@onready var timer: Timer = $Timer

@export var enemyPrefab: PackedScene
@export var spawnDelay := 2.0
@export var minSpawnDist := 75.0
@export var maxSpawnDist := 200.0

func spawn_enemy() -> void:
	var player := get_tree().get_first_node_in_group("player") as Player
	if not player:
		return
	var enemy := enemyPrefab.instantiate() as Enemy
	get_parent().add_child(enemy)
	var angle := randf_range(0, TAU)
	var dist := randf_range(minSpawnDist, maxSpawnDist)
	enemy.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * dist

func _ready() -> void:
	timer.wait_time = spawnDelay
	timer.start()

func _on_timer_timeout() -> void:
	spawn_enemy()
