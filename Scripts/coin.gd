class_name Coin

extends Area2D

@export var xpAmount : int

func _on_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player:
		player.increase_xp(xpAmount)
		queue_free()
