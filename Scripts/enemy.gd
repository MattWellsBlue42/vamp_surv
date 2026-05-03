class_name Enemy

extends CharacterBody2D

@export var dropsPrefab: PackedScene
@export var rangedAttacker := false

@onready var level: Level = get_parent() as Level
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_component: AnimationComponent = %AnimationComponent
@onready var stats_component: StatsComponent = %StatsComponent
@onready var movement_component: MovementComponent = %MovementComponent
@onready var attack_component: AttackComponent = %AttackComponent
@onready var projectile_attack_component: ProjectileAttackComponent = %ProjectileAttackComponent

func _physics_process(_delta: float) -> void:
	movement_component.move_towards(level.player.global_position)
	animation_component.set_moving(velocity.length() > 10.0)

func _ready() -> void:
	timer.start(stats_component.stats.attackCooldown)
	stats_component.died.connect(_on_death)

	if !rangedAttacker:
		attack_component.attackRange = stats_component.stats.attackRange
		attack_component.attackDamage = stats_component.stats.damage
		attack_component._setup_collision()
		attack_component.groupToHit = "player"
	else:
		projectile_attack_component.groupToHit = "player"
		projectile_attack_component.hitMask = 18
		projectile_attack_component.damage = stats_component.stats.damage
	
	movement_component.speed = stats_component.stats.speed

func _on_death() -> void:
	attack_component.ableToAttack = false
	die()

func spawn_pickup() -> void:
	var drop := dropsPrefab.instantiate() as Coin
	drop.global_position = self.global_position
	drop.xpAmount = stats_component.stats.xpDrop
	get_parent().add_child(drop)
	queue_free()

func die() -> void:
	animation_player.play("death")

func _on_timer_timeout() -> void:
	if rangedAttacker:
		projectile_attack_component.fire_projectile()
	else:
		attack_component.attack()