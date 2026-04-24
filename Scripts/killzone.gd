class_name KillBox

extends Area2D

@onready var timer: Timer = $Timer
@onready var debugLabel: Label = $Label

@export var instaKill : bool
@export var damage : int
@export var attackDelay : int

var canAttack := true

func _ready() -> void:
	debugLabel.visible = GameManager.DEBUG_MODE

func _process(_delta: float) -> void:
	if GameManager.DEBUG_MODE:
		debugLabel.text = "cooldown: " + str(snappedf(timer.time_left, 0.01)) + "\ninstaKill: " + str(instaKill)

func _on_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player:
		if instaKill:
			player.die()
		else:
			if canAttack:
				canAttack = false
				timer.start(float(attackDelay))
				player.take_damage(damage)


func _on_timer_timeout() -> void:
	canAttack = true
	pass # Replace with function body.
