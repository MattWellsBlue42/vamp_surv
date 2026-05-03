class_name AttackComponent

extends Node

var attack_flash: Polygon2D
@export var body: CharacterBody2D
@export var meleeSwipeArea: Area2D

var ableToAttack := true

var groupToHit: String

var attackRange := 0
var attackDamage: float = 0.0

var overtimeEffects: Array[OverTimeEffect] = []

func attack() -> void:
	if !ableToAttack:
		return
	
	var collision := meleeSwipeArea.get_child(0) as CollisionShape2D
	collision.disabled = false
	var closestEnemy := get_nearest_enemy()
	if closestEnemy:
		meleeSwipeArea.look_at(closestEnemy.global_position)
		attack_flash.modulate.a = 0.8
		var tween := create_tween()
		tween.tween_property(attack_flash, "modulate:a", 0.0, 0.15)
		var shape_query := PhysicsShapeQueryParameters2D.new()
		shape_query.shape = collision.shape
		shape_query.transform = meleeSwipeArea.global_transform * collision.transform
		shape_query.collision_mask = meleeSwipeArea.collision_mask
		var hits := body.get_world_2d().direct_space_state.intersect_shape(shape_query)
		for hit in hits:
			if hit.collider:
				hit.collider.stats_component.take_damage(attackDamage, overtimeEffects)
	collision.disabled = true

#region Helpers
func get_nearest_enemy() -> Node:
	var nearest: Node = null
	var nearest_dist := INF
	for enemy in body.get_tree().get_nodes_in_group(groupToHit):
		var dist: float = body.global_position.distance_to(enemy.global_position)
		if dist < nearest_dist and dist <= attackRange:
			nearest = enemy
			nearest_dist = dist

	return nearest
#endregion

#region WhiteFlashVisual
func _setup_collision() -> void:
	meleeSwipeArea.position = Vector2.ZERO
	var collision := meleeSwipeArea.get_child(0) as CollisionShape2D
	collision.position = Vector2(roundi(attackRange / 2.0), 0)
	collision.scale = Vector2.ONE
	collision.shape.size = Vector2(attackRange + 5, collision.shape.size.y)
	_setup_flash(collision)

func _setup_flash(collision: CollisionShape2D) -> void:
	if attack_flash:
		attack_flash.queue_free()
	var s: Vector2 = collision.shape.size
	attack_flash = Polygon2D.new()
	attack_flash.polygon = PackedVector2Array([
		Vector2(-s.x / 2.0, -s.y / 2.0),
		Vector2(s.x / 2.0, -s.y / 2.0),
		Vector2(s.x / 2.0, s.y / 2.0),
		Vector2(-s.x / 2.0, s.y / 2.0),
	])
	attack_flash.color = Color.WHITE
	attack_flash.modulate.a = 0.0
	attack_flash.position = collision.position
	meleeSwipeArea.add_child(attack_flash)
#endregion
