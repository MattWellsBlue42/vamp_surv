class_name MovementComponent

extends Node

@export var body: CharacterBody2D
@export var sprite: Node2D

var speed: float

var direction := Vector2.ZERO
@export var maxDistAway := 0

func move_towards(targetPos: Vector2) -> void:
    if body.global_position.distance_to(targetPos) < maxDistAway:
        body.velocity = Vector2.ZERO
        return

    var distanceToPLayer := body.global_position.direction_to(targetPos)
    var velo := distanceToPLayer * speed

    body.velocity = velo

    body.move_and_slide()

func tick() -> void:
    if body == null:
        print("Assign a body to the movement component")
        return

    # Movement
    body.velocity.x = direction.x * speed
    body.velocity.y = direction.y * speed

    if direction.x > 0:
        sprite.flip_h = false
    elif direction.x < 0:
        sprite.flip_h = true
        

    body.move_and_slide()