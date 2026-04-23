class_name BaseCustomPicker
extends PanelContainer

const MAIN_MENU = preload("res://scenes/main_menu/main_menu.tscn")

@onready var base: Button = %Base
@onready var custom: Button = %Custom
@onready var exit_level_picker: Button = %ExitLevelPicker
@onready var base_level_picker: LevelPicker = %BaseLevelPicker
@onready var custom_level_picker: LevelPicker = %CustomLevelPicker


func _ready() -> void:
	exit_level_picker.pressed.connect(_on_exit_level_picker_pressed)
	base.pressed.connect(_flip_base_custom)
	custom.pressed.connect(_flip_base_custom)
	base_level_picker.level_picked.connect(_on_level_picked)
	custom_level_picker.level_picked.connect(_on_level_picked)
	
	base_level_picker.set_levels(Level.get_default_levels())
	
	for level in range(PlayerData.get_instance().get_reached_level()):
		base_level_picker.unlock_level(level+1)
	
	var user_levels := Level.get_user_levels()
	if user_levels:
		custom_level_picker.set_levels(user_levels)
		custom_level_picker.unlock_all()


# There is actually a node we should use... Maybe? TabContainer
func _flip_base_custom():
	custom.disabled = !custom.disabled
	custom_level_picker.visible = !custom_level_picker.visible
	base.disabled = !base.disabled
	base_level_picker.visible = !base_level_picker.visible


## Creates a new map
func _on_level_picked(levels: Array[Level], level: int):
	var game: Game = Game.create_scene(levels, level)
	add_sibling(game)
	get_tree().current_scene = game
	queue_free()


func _on_exit_level_picker_pressed():
	get_tree().change_scene_to_packed(MAIN_MENU)
