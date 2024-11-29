extends MarginContainer

func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")




func _input(event):
	if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_RIGHT:
		var held_tile = $VBoxContainer/TileMap.held_tile
		if held_tile:
			held_tile.rotate()
			$VBoxContainer/TileMap.held_tile = held_tile
	if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_LEFT:
		$VBoxContainer/TileMap.place()


func _on_save_pressed() -> void:
	$VBoxContainer/TileMap.to_level().save_to_file()
