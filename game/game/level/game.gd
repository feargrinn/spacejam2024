class_name Game
extends Node

var current_map: LevelTileMap
var current_level

const END_SCREEN = preload("uid://bx33hrjamvvs3")
const VICTORY_SCREEN = preload("uid://c5jhprfubvllq")
const BASE_CUSTOM_PICKER = preload("uid://brv51q227veyq")

@onready var grid_map_layer: CanvasLayer = $GridMapLayer
@onready var controls: CanvasLayer = $Controls
@onready var tile_picker: VBoxContainer = %TilePicker


func _ready():
	for tile_type in TileType.pipe_types:
		var tile_button := _create_button(tile_type)
		tile_picker.add_child(tile_button)
		tile_button.tile_picked_up.connect(
			func(tile: TileId):
				current_map.tile = tile
				)


##Goes back to lever picker
func _on_exit_level_pressed():
	get_tree().change_scene_to_packed(BASE_CUSTOM_PICKER)
	queue_free()


## Creates clickable tile buttons
func _create_button(tile_type: TileType.Type) -> PickableTile:
	var container = PickableTile.new(TileType.coordinates(tile_type), TileType.texture(tile_type))
	return container


func _on_next_level_pressed():
	if false: #custom_levels_visible:
		_on_exit_level_pressed()
	else:
		var base_custom_picker: BaseCustomPicker = BASE_CUSTOM_PICKER.instantiate()
		add_sibling(base_custom_picker)
		reparent(base_custom_picker)
		base_custom_picker.level_picker.unlock_level(current_level + 1)
		base_custom_picker.level_picker.click_level_button(current_level + 1)


func victory_screen():
	if true: #custom_levels_visible or (current_level != level_picker.max_level()):
		var victory_scene: VictoryScreen = VICTORY_SCREEN.instantiate()
		controls.add_child(victory_scene)
		victory_scene.next_level_requested.connect(_on_next_level_pressed)
	else:
		controls.add_child(END_SCREEN.instantiate())


func _on_retry_pressed():
	var new_map = LevelTileMap.custom_new(current_map.level_data)
	for child in grid_map_layer.get_children():
		child.queue_free()
	grid_map_layer.add_child(new_map, true)
	current_map = new_map


func loser_screen(losing_outputs: Dictionary):
	var loser_scene := LoserScreen.custom_new(losing_outputs)
	controls.add_child(loser_scene)
	loser_scene.retry_requested.connect(_on_retry_pressed)
	loser_scene.retry_requested.connect(loser_scene.queue_free)
