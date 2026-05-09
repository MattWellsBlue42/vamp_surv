class_name InputComponent

extends Node

var moveDir := Vector2.ZERO
var attackPressed := false

func update() -> void:
	moveDir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	attackPressed = Input.is_action_just_pressed("attack")