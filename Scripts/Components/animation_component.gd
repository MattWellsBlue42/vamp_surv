class_name AnimationComponent

extends Node

@export var sprite: Sprite2D

@export var idle_stretch_freq: float = 1.5  # idle: how fast it squishes (higher = faster bob)
@export var idle_stretch_amp: float = 0.06  # idle: how much it squishes (higher = more dramatic)
@export var idle_rotate_freq: float = 1.1   # idle: how fast it sways (higher = faster sway)
@export var idle_rotate_amp: float = 0.04   # idle: how far it sways (higher = wider tilt)

@export var move_stretch_freq: float = 3.2  # moving: how fast it squishes
@export var move_stretch_amp: float = 0.12  # moving: how much it squishes
@export var move_rotate_freq: float = 3.0   # moving: how fast it sways
@export var move_rotate_amp: float = 0.08   # moving: how far it sways

var t_stretch: float = 0.0
var t_rotate: float = PI / 2.0  # offset so peaks don't align

var _moving: bool = false

func set_moving(moving: bool) -> void:
	_moving = moving

func _process(delta: float) -> void:
	var s_freq := move_stretch_freq if _moving else idle_stretch_freq
	var s_amp  := move_stretch_amp  if _moving else idle_stretch_amp
	var r_freq := move_rotate_freq  if _moving else idle_rotate_freq
	var r_amp  := move_rotate_amp   if _moving else idle_rotate_amp

	t_stretch += delta * s_freq
	t_rotate  += delta * r_freq

	sprite.scale.y = 1.0 + sin(t_stretch) * s_amp
	sprite.rotation = sin(t_rotate) * r_amp
