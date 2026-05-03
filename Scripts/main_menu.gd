class_name MainMenu

extends Control

signal level_chosen(level: int)

func _on_level_1_pressed() -> void:
	level_chosen.emit(1)


func _on_quit_pressed() -> void:
	get_tree().quit()
