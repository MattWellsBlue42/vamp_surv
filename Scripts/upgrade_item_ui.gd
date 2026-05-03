class_name UpgradeItemUI

extends Control


#? References for the Spawners of this element can have easy access
func set_item_info(icon: AtlasTexture, _itemname: String, desc: String) -> void:
	$MarginContainer/VBoxContainer/ItemIcon.texture = icon
	$MarginContainer/VBoxContainer/ItemName.text = _itemname
	$MarginContainer/VBoxContainer/MarginContainer/ItemDesc.text = desc