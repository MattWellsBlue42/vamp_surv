class_name Player

extends CharacterBody2D
@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var debug_label: Label = $DEBUG

signal hp_changed(new_hp: int)
signal leveled_up(level: int)

@export var stats: PlayerStats
@export var godMode: bool

var level: int = 1
var levelUpAmount := 50
var xp := 0

func attack() -> void:
	var enemyToAttack := get_nearest_enemy()
	if enemyToAttack:
		enemyToAttack.take_damage(stats.damage)

func get_nearest_enemy() -> Enemy:
	var nearest: Enemy = null
	var nearest_dist := INF
	for enemy in get_parent().get_tree().get_nodes_in_group("enemies"):
		var dist: float = global_position.distance_to(enemy.global_position)
		if dist < nearest_dist and dist <= stats.attackRange:
			nearest = enemy
			nearest_dist = dist
			
	return nearest

func level_up() -> void:
	level += 1
	levelUpAmount = roundi(levelUpAmount * 1.6)
	leveled_up.emit(level)

func increase_xp(amount: int) -> void:
	var newXP := xp + amount
	if newXP >= levelUpAmount:
		xp = newXP - levelUpAmount
		level_up()
	else:
		xp = newXP

func take_damage(amount: int) -> void:
	if godMode:
		pass
	else:
		var newHp := int(clamp(stats.hp - amount, 0, stats.maxHp))
		stats.hp = newHp
		hp_changed.emit(newHp)
	
func die() -> void:
	if godMode:
		pass
	else:
		stats.hp = 0
		hp_changed.emit(0)

func _draw() -> void:
	if GameManager.DEBUG_MODE:
		draw_circle(Vector2.ZERO, stats.attackRange, Color(1, 1, 0, 0.2))
		draw_arc(Vector2.ZERO, stats.attackRange, 0, TAU, 32, Color(1, 1, 0, 0.8), 1.0)

func _process(_delta: float) -> void:
	if GameManager.DEBUG_MODE:
		debug_label.text = "xp: " + str(xp) + "\nhp: " + str(stats.hp) + "\nlevel: " + str(level)
		queue_redraw()
		

func _ready() -> void:
	debug_label.visible = GameManager.DEBUG_MODE
	timer.start(stats.attackCooldown)

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
	
	if direction.y:
		velocity.y = direction.y * stats.speed
	else:
		velocity.y = move_toward(velocity.y, 0, stats.speed)

	if direction.x:
		velocity.x = direction.x * stats.speed
	else:
		velocity.x = move_toward(velocity.x, 0, stats.speed)

	move_and_slide()


func _on_timer_timeout() -> void:
	attack()
