class_name MainUI

extends CanvasLayer

@onready var health_bar: ProgressBar = $HealthBar

var player: Player

func _ready() -> void:
	player = GameManager.player
	health_bar.max_value = player.stats.maxHp
	player.hp_changed.connect(_on_hp_changed)

func _on_hp_changed(newHp: int) -> void:
	health_bar.value = newHp