class_name Game
extends Node

var current_map: LevelTileMap
var current_level: int #ugh

const END_SCREEN = preload("uid://bx33hrjamvvs3")
const VICTORY_SCREEN = preload("uid://c5jhprfubvllq")
const BASE_CUSTOM_PICKER_UID: String = "uid://brv51q227veyq"

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
	get_tree().change_scene_to_file(BASE_CUSTOM_PICKER_UID)


## Creates clickable tile buttons
func _create_button(tile_type: TileType.Type) -> PickableTile:
	var container = PickableTile.new(TileType.coordinates(tile_type), TileType.texture(tile_type))
	return container


func _on_next_level_pressed():
	if false: #custom_levels_visible:
		_on_exit_level_pressed()
	else:
		var loaded_levels = Level.load_default()
		if loaded_levels is Error:
			print("Failed to load levels: ", loaded_levels.as_string(), ".")
		print("Loaded ", loaded_levels.size(), " levels.")
		if current_level + 1 >= loaded_levels.size():
			print_debug("Level out of bounds")
			return
		
		current_level += 1
		refresh_map(loaded_levels[current_level])


func _on_retry_pressed():
	refresh_map(current_map.level_data)


func victory_screen():
	if true: #custom_levels_visible or (current_level != level_picker.max_level()):
		var victory_scene: VictoryScreen = VICTORY_SCREEN.instantiate()
		controls.add_child(victory_scene)
		victory_scene.next_level_requested.connect(_on_next_level_pressed, CONNECT_ONE_SHOT)
		victory_scene.next_level_requested.connect(victory_scene.queue_free, CONNECT_ONE_SHOT)
	else:
		controls.add_child(END_SCREEN.instantiate())


func refresh_map(level_data: Level) -> void:
	for child in grid_map_layer.get_children():
		grid_map_layer.remove_child(child)
		child.queue_free()
	
	var new_map = LevelTileMap.custom_new(level_data)
	grid_map_layer.add_child(new_map, true)
	current_map = new_map


func loser_screen(losing_outputs: Dictionary):
	var loser_scene := LoserScreen.custom_new(losing_outputs)
	controls.add_child(loser_scene)
	loser_scene.retry_requested.connect(_on_retry_pressed, CONNECT_ONE_SHOT)
	loser_scene.retry_requested.connect(loser_scene.queue_free, CONNECT_ONE_SHOT)
