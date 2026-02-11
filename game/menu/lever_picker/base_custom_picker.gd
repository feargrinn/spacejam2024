class_name BaseCustomPicker
extends PanelContainer

var level_picker: LevelPicker
var custom_level_picker: LevelPicker
var save_data: PlayerData
var custom_levels_visible: bool


@onready var base: Button = %Base
@onready var custom: Button = %Custom
@onready var exit_level_picker: Button = %ExitLevelPicker


# Loads levels player has accessible, custom levels
func _ready() -> void:
	exit_level_picker.pressed.connect(_on_exit_level_picker_pressed)
	base.pressed.connect(_on_base_pressed)
	custom.pressed.connect(_on_custom_pressed)
	
	var loaded_levels = Level.load_default()
	if loaded_levels is Error:
		print("Failed to load levels: ", loaded_levels.as_string(), ".")
	print("Loaded ", loaded_levels.size(), " levels.")
	level_picker = LevelPicker.new(loaded_levels, self._on_level_pressed)
	$VBoxContainer.add_child(level_picker)
	level_picker.show()
	$VBoxContainer/HBoxContainer/Base.set_disabled(true)
	var loaded_data = PlayerData.load_default()
	if loaded_data is Error:
		print("Failed to load game state: ", loaded_data.as_string(), ".")
		save_data = PlayerData.new()
	else:
		save_data = loaded_data
	for level in range(save_data.get_reached_level()):
		level_picker.unlock_level(level+1)
	var loaded_user_levels = Level.load_user()
	if loaded_user_levels is Error:
		print("Failed to load user levels: ", loaded_user_levels.as_string(), ".")
	else:
		print("Loaded ", loaded_user_levels.size(), " custom levels.")
		if len(loaded_user_levels) > 0:
			custom_level_picker = LevelPicker.new(loaded_user_levels, self._on_level_pressed)
			custom_level_picker.unlock_all()
			custom_level_picker.hide()
			custom_levels_visible = false
			$VBoxContainer.add_child(custom_level_picker)
			$VBoxContainer/HBoxContainer/Custom.set_disabled(false)

## Shows button for unlocked level and saves in player data that lvl is unlocked
func unlock_level(level: int):
	level_picker.unlock_level(level)
	save_data.unlock_level(level)

func _on_custom_pressed():
	$VBoxContainer/HBoxContainer/Custom.set_disabled(true)
	$VBoxContainer/HBoxContainer/Base.set_disabled(false)
	level_picker.hide()
	custom_level_picker.show()
	custom_levels_visible = true

func _on_base_pressed():
	$VBoxContainer/HBoxContainer/Base.set_disabled(true)
	$VBoxContainer/HBoxContainer/Custom.set_disabled(false)
	custom_level_picker.hide()
	level_picker.show()
	custom_levels_visible = false

## Creates a new map
func _on_level_pressed(levels: Array[Level], level: int):
	print("level_pressed")
	var game = load("res://game/level/game.tscn")
	var level_instance = game.instantiate()
	level_instance.current_level = level
	var new_map = LevelTileMap.new(levels[level-1])
	level_instance.get_node("2D").add_child(new_map)
	#new_map.owner = level_instance
	level_instance.current_map = new_map
	level_instance.current_map.show()
	get_tree().root.add_child(level_instance)
	queue_free()

func _on_exit_level_picker_pressed():
	get_tree().change_scene_to_file("res://menu/main_menu/main_menu.tscn")
	queue_free()
