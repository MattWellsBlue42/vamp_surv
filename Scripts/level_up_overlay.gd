class_name LevelUpOverlay

extends Control

signal on_button_pressed(optionChosen: int)

@export var upgradeItemScene: PackedScene
@export var upgradeItemButton: PackedScene
@export var spriteSheet: CompressedTexture2D

var hoveringColor := Color(18.892, 18.892, 18.892, 1)
var inactiveColor := Color(18.892, 18.892, 18.892, 0.175)

var spriteSize := Vector2(32, 32)
var spriteLocations := {
	"sharpness": Vector2(7, 45),
	"swift_attack": Vector2(4, 45),
	"poison": Vector2(1, 45),
	"bleed": Vector2(13, 45),
	"life_steal": Vector2(9, 45),
	"max_hp": Vector2(2, 41),
	"speed_up": Vector2(1, 41),
}

var buttons: Array[UpgradeItemButton]

func find_sprite_from_sheet(spriteName: String) -> AtlasTexture:
	var spritePos: Vector2 = spriteLocations.get("_".join(spriteName.to_lower().split(" ")), Vector2.ZERO)
	var sprite := AtlasTexture.new()
	sprite.atlas = spriteSheet
	sprite.region = Rect2(clamp(spritePos.x * spriteSize.x, 0, INF), clamp(spritePos.y * spriteSize.y, 0, INF), 32, 32)
	return sprite

func show_options(options: Dictionary[int, UpgradeItemInfo]) -> void:
	var container := $HBoxContainer
	for child in container.get_children():
		container.remove_child(child)

	if upgradeItemScene:
		for option: int in options.keys():
			var upgradeButton := upgradeItemButton.instantiate() as UpgradeItemButton
			upgradeButton.on_button_pressed.connect(_on_button_pressed.bind(option))
			buttons.append(upgradeButton)
			$HBoxContainer.add_child(upgradeButton)
			var upgradeItemUI := upgradeItemScene.instantiate() as UpgradeItemUI
			upgradeItemUI.set_item_info(find_sprite_from_sheet(options[option].upgradeName), options[option].upgradeName, options[option].description)
			upgradeButton.add_child(upgradeItemUI)

func _on_button_pressed(optionNum: int) -> void:
	on_button_pressed.emit(optionNum)
