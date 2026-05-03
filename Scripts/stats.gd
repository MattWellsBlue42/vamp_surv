class_name CharacterStats

extends Resource

#? Damage
@export var damage: float = 10.0

#? Attack
@export var attackRange := 80
@export var attackCooldown: float = 1.0
@export var attackSpeed: int = 10

#? HP
@export var maxHp: float = 100.0
@export var hp := maxHp

#? Speed
@export var speed := 100.0

#? XP
@export var xpMultiplier := 1.0
@export var xpDrop := 10