extends Node
var DEBUG_MODE := true

func _ready() -> void:
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
