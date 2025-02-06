extends MarginContainer

var level_name

func _ready() -> void:
	var name_edit = $VBoxContainer/LevelName
	name_edit.connect("focus_entered", _on_level_name_focus_entered.bind(name_edit))
	name_edit.connect("text_submitted", _on_level_name_text_submitted.bind(name_edit))
	name_edit.connect("gui_input", _on_level_name_gui_input.bind(name_edit))

func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu/main_menu/menu.tscn")

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


func _on_level_name_focus_entered(edit_node) -> void:
	level_name = edit_node.text

func _on_level_name_text_submitted(text, edit_node) -> void:
	level_name = text
	edit_node.release_focus()


func _on_level_name_gui_input(input_event : InputEvent, edit_node) -> void:
	if input_event is InputEventKey and input_event.pressed == true and input_event.keycode == KEY_ESCAPE:
		edit_node.text = level_name
