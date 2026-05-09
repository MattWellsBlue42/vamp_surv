class_name Projectile

extends CharacterBody2D

var speed := 200
var direction: Vector2
var damage: float

func _physics_process(_delta: float) -> void:
	velocity = direction * speed

	move_and_slide()

	if get_slide_collision_count() > 0:
		var collider := get_slide_collision(0).get_collider()
		if collider is TileMapLayer:
			queue_free()
		else:
			collider.stats_component.take_damage(damage, [] as Array[OverTimeEffect], [] as Array[InstantEffect])
			queue_free()