class_name UpgradeItemButton

extends Button

# @onready var itemContainer: NinePatchRect = $NinePatchRect

signal on_button_pressed()

func _on_pressed() -> void:
	on_button_pressed.emit()
