class_name Player

extends CharacterBody2D
@onready var timer: Timer = $Timer
@onready var sprite: Sprite2D = %Sprite2D
@onready var melee_swipe: Area2D = $MeleeSwipe
@onready var input_component: InputComponent = %InputComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var stats_component: StatsComponent = %StatsComponent
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var attack_component: AttackComponent = %AttackComponent
@onready var projectile_attack_component: ProjectileAttackComponent = %ProjectileAttackComponent
		
var overtimeEffects: Array[OverTimeEffect]

func _input(event: InputEvent) -> void:
	pass
	if event.is_pressed():
		if event is InputEventKey and OS.get_keycode_string(event.keycode) == "L":
			stats_component.level_up()
		if event is InputEventKey and OS.get_keycode_string(event.keycode) == "F":
			projectile_attack_component.fire_projectile()
		if event is InputEventKey and OS.get_keycode_string(event.keycode) == "Minus":
			print("Death")
			# stats_component.take_damage(stats_component.stats.hp)
			# pass

func _process(_delta: float) -> void:
	attack_component.overtimeEffects = overtimeEffects

func _ready() -> void:
	timer.start(stats_component.stats.attackCooldown)
	stats_component.died.connect(_on_death)
	attack_component.attackRange = stats_component.stats.attackRange
	attack_component.attackDamage = stats_component.stats.damage
	attack_component._setup_collision()
	attack_component.groupToHit = "enemies"
	projectile_attack_component.hitMask = 20
	projectile_attack_component.groupToHit = "enemies"

func _physics_process(_delta: float) -> void:
	if stats_component.stats.hp <= 0.0:
		return

	#? Read Controls
	input_component.update()
	
	movement_component.speed = stats_component.stats.speed
	movement_component.direction = input_component.moveDir
	movement_component.tick()

	animation_component.set_moving(velocity.length() > 10.0)

func _on_death() -> void:
	attack_component.ableToAttack = false
	collision_shape.set_deferred("disabled", true)

func _on_timer_timeout() -> void:
	attack_component.attack()

func edit_attack_cooldown(newVal: float) -> void:
	print("Setting new cooldown: " + str(newVal))
	timer.wait_time = newVal

func attack_range_changed(newVal: int) -> void:
	stats_component.stats.attackRange = newVal
	attack_component.attackRange = newVal
	attack_component._setup_collision()
