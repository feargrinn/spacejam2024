class_name BaseCustomPicker
extends PanelContainer

const GAME = preload("uid://fhmwenm3h7c7")
const MAIN_MENU = preload("uid://b6ldch5v2bfc3")


var save_data: PlayerData


@onready var base: Button = %Base
@onready var custom: Button = %Custom
@onready var exit_level_picker: Button = %ExitLevelPicker
@onready var base_level_picker: LevelPicker = %BaseLevelPicker
@onready var custom_level_picker: LevelPicker = %CustomLevelPicker


# Loads levels player has accessible, custom levels
func _ready() -> void:
	exit_level_picker.pressed.connect(_on_exit_level_picker_pressed)
	base.pressed.connect(_flip_base_custom)
	custom.pressed.connect(_flip_base_custom)
	base_level_picker.level_picked.connect(_on_level_picked)
	custom_level_picker.level_picked.connect(_on_level_picked)
	
	var loaded_levels = Level.load_default()
	if loaded_levels is Error:
		print("Failed to load levels: ", loaded_levels.as_string(), ".")
	print("Loaded ", loaded_levels.size(), " levels.")
	base_level_picker.levels = loaded_levels
	
	var loaded_data = PlayerData.load_default()
	if loaded_data is Error:
		print("Failed to load game state: ", loaded_data.as_string(), ".")
		save_data = PlayerData.new()
	else:
		save_data = loaded_data
	for level in range(save_data.get_reached_level()):
		base_level_picker.unlock_level(level+1)
	
	var loaded_user_levels = Level.load_user()
	if loaded_user_levels is Error:
		print("Failed to load user levels: ", loaded_user_levels.as_string(), ".")
	else:
		print("Loaded ", loaded_user_levels.size(), " custom levels.")
		if len(loaded_user_levels) > 0:
			custom_level_picker.levels = loaded_user_levels
			custom_level_picker.unlock_all()


## Shows button for unlocked level and saves in player data that lvl is unlocked
func unlock_level(level: int):
	base_level_picker.unlock_level(level)
	save_data.unlock_level(level)


# There is actually a node we should use... Maybe? TabContainer
func _flip_base_custom():
	custom.disabled = !custom.disabled
	custom_level_picker.visible = !custom_level_picker.visible
	base.disabled = !base.disabled
	base_level_picker.visible = !base_level_picker.visible


## Creates a new map
func _on_level_picked(levels: Array[Level], level: int):
	var level_instance: Game = GAME.instantiate()
	level_instance.current_level = level
	var new_map = LevelTileMap.custom_new(levels[level])
	level_instance.current_map = new_map
	level_instance.current_map.show()
	get_tree().root.add_child(level_instance)
	get_tree().current_scene = level_instance
	level_instance.grid_map_layer.add_child(new_map)
	queue_free()


func _on_exit_level_picker_pressed():
	get_tree().change_scene_to_packed(MAIN_MENU)
