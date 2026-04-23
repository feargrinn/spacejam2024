class_name Editor
extends MarginContainer

@onready var level_name: LineEditWithMemory = %LevelName
@onready var tile_picker: TilePicker = $VBoxContainer/TilePicker
@onready var level_tile_map: LevelTileMap = $VBoxContainer/LevelTileMap


func _ready() -> void:
	tile_picker.tile_picked_up.connect(level_tile_map.set_held_pipe)


#func _input(event):
	#if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_RIGHT:
		#var held_tile = $VBoxContainer/TileMap.held_tile
		#if held_tile:
			#held_tile.rotate()
			#$VBoxContainer/TileMap.held_tile = held_tile
	#if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_LEFT:
		#$VBoxContainer/TileMap.place()


func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu/main_menu/main_menu.tscn")


#func _on_save_pressed() -> void:
	#$VBoxContainer/TileMap.to_level().save_to_file()
