extends MarginContainer

func _on_back_pressed():
	get_tree().change_scene_to_file("res://node_2d.tscn")




func _input(event):
	if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_RIGHT:
		var held_tile = $VBoxContainer/TileMap.held_tile
		if held_tile:
			if $VBoxContainer/TileMap/background.tile_set.get_source(0).has_alternative_tile(held_tile[0], held_tile[1] + 1):
				held_tile[1] = (held_tile[1] + 1)
			else:
				held_tile[1] = 0
			$VBoxContainer/TileMap.held_tile = held_tile
	if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_LEFT:
		$VBoxContainer/TileMap.place()


func _on_save_pressed() -> void:
	$SaveLevelDialog.show()


func _on_save_level_dialog_confirmed() -> void:
	var dialog = $SaveLevelDialog
	print(dialog.current_file)
	var file = FileAccess.open("user://levels/" + dialog.current_file, FileAccess.WRITE)
	var level_name = dialog.current_file.split(".")[0]
	file.store_string(JSON.stringify($VBoxContainer/TileMap.to_json(level_name)))
