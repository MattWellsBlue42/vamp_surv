class_name ProjectileAttackComponent

extends Node

@export var body: CharacterBody2D
@export var projectile: PackedScene
var hitMask: int

var groupToHit: String

var damage: float

func fire_projectile() -> void:
    var closestEnemy := get_nearest_enemy() as CharacterBody2D
    if closestEnemy:
        var fired := projectile.instantiate() as Projectile
        body.get_parent().add_child(fired)
        fired.global_position = body.global_position
        fired.direction = body.global_position.direction_to(closestEnemy.global_position)
        fired.collision_mask = hitMask
        fired.damage = damage

func get_nearest_enemy() -> Node:
    var nearest: Node = null
    var nearest_dist := INF
    for enemy in body.get_tree().get_nodes_in_group(groupToHit):
        var dist := body.global_position.distance_squared_to(enemy.global_position)
        if dist < nearest_dist:
            nearest_dist = dist
            nearest = enemy
    return nearest