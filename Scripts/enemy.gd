class_name Enemy

extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var dropsPrefab: PackedScene
@export var xpDropAmount := 15
@export var maxHp := 20
@export var speed := 30

var hp := maxHp
var _hp_label: Label

func _ready() -> void:
	hp = maxHp
	if GameManager.DEBUG_MODE:
		_hp_label = Label.new()
		_hp_label.position = Vector2(-8, -20)
		_hp_label.add_theme_font_size_override("font_size", 8)
		add_child(_hp_label)
		_update_hp_label()

func _update_hp_label() -> void:
	if _hp_label:
		_hp_label.text = str(hp) + "/" + str(maxHp)

func move_towards_player(_delta: float) -> void:
	var distanceToPLayer := global_position.direction_to(GameManager.player.global_position)
	var velo := distanceToPLayer * speed

	velocity = velo

	move_and_slide()
	

func spawn_pickup() -> void:
	var drop := dropsPrefab.instantiate() as Coin
	drop.global_position = self.global_position
	drop.xpAmount = xpDropAmount
	get_parent().add_child(drop)
	queue_free()

func die() -> void:
	animation_player.play("death")

func take_damage(amount: int) -> void:
	var newHP := int(clamp(hp - amount, 0, hp))
	hp = newHP
	_update_hp_label()
	if newHP == 0:
		die()

func _physics_process(delta: float) -> void:
	move_towards_player(delta)
