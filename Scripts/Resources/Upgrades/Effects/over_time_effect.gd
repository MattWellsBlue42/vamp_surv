class_name OverTimeEffect

extends Resource

enum effect_types {POISON, BLEED, NONE}

@export var effectType: effect_types = effect_types.NONE

@export var value: float
@export var duration: float
@export var tickRate: float