class_name EnemySpawner

extends Node

@onready var timer: Timer = $Timer

@export var enemyPrefabs: Array[PackedScene]
@export var spawnDelay := 2.0
@export var minSpawnDist := 75.0
@export var maxSpawnDist := 200.0

var spawnChances := {
	'mage': 20,
	'cyclops': 80
}

func spawn_enemy() -> void:
	var player := get_tree().get_first_node_in_group("player") as Player
	if not player:
		return
	var angle := randf_range(0, TAU)
	var dist := randf_range(minSpawnDist, maxSpawnDist)
	var ran := int(randf() * 100)
	if ran > spawnChances['mage']:
		var randEnemy := enemyPrefabs[0]
		var enemy := randEnemy.instantiate() as Enemy
		enemy.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * dist
		get_parent().add_child(enemy)
	else:
		var randEnemy := enemyPrefabs[1]
		var enemy := randEnemy.instantiate() as Enemy
		enemy.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * dist
		get_parent().add_child(enemy)
		

func _ready() -> void:
	timer.wait_time = spawnDelay
	timer.start()

func _on_timer_timeout() -> void:
	spawn_enemy()
