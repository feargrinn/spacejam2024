class_name Editor
extends MarginContainer

@onready var level_name: LineEditWithMemory = %LevelName
@onready var tile_picker: TilePicker = $VBoxContainer/TilePicker
@onready var creator_tile_map: CreatorTileMap = $VBoxContainer/CreatorTileMap

@onready var main_menu_button: Button = %MainMenuButton
@onready var load_button: Button = %LoadButton
@onready var save_button: Button = %SaveButton


func _ready() -> void:
	tile_picker.tile_picked_up.connect(creator_tile_map.set_held_pipe)
	main_menu_button.pressed.connect(_on_back_pressed)


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
