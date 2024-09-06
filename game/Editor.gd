extends MarginContainer

func _on_back_pressed():
	get_tree().change_scene_to_file("res://node_2d.tscn")




func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_RIGHT:
		var held_tile = $VBoxContainer/TileMap.held_tile
		if held_tile:
			held_tile[1] = (held_tile[1] + 1) % 4
			$VBoxContainer/TileMap.held_tile = held_tile
	if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_LEFT:
		$VBoxContainer/TileMap.place()
