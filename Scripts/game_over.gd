class_name GameOver

extends Control

@onready var youSurvivedLabel: Label = $PanelContainer/MarginContainer/VBoxContainer2/Label2

signal back_to_main_menu()
signal retry(retryLevel: int)

func _on_retry_pressed() -> void:
	retry.emit(1)

func _on_main_menu_pressed() -> void:
	back_to_main_menu.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
