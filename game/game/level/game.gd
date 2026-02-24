class_name Game
extends Node

var loaded_base_levels: Array[Level]
var current_level: int #ugh

const END_SCREEN = preload("uid://bx33hrjamvvs3")
const VICTORY_SCREEN = preload("uid://c5jhprfubvllq")
const BASE_CUSTOM_PICKER_UID: String = "uid://brv51q227veyq"
const GAME = preload("uid://fhmwenm3h7c7")


@onready var controls: CanvasLayer = $Controls
@onready var tile_picker: VBoxContainer = %TilePicker
@onready var level_tile_map: LevelTileMap = %LevelTileMap


static func create_scene(base_levels: Array[Level], level_id: int) -> Game:
	var game: Game = GAME.instantiate()
	game.loaded_base_levels = base_levels
	game.current_level = level_id
	return game


func _ready():
	for tile_type in TileType.pipe_types:
		var tile_button := _create_button(tile_type)
		tile_picker.add_child(tile_button)
		tile_button.tile_picked_up.connect(
			func(tile: TileId):
				level_tile_map.tile = tile
				)
	
	level_tile_map.set_level(loaded_base_levels[current_level])
	level_tile_map.animation_losing_finished.connect(loser_screen)
	level_tile_map.animation_winning_finished.connect(victory_screen)
	level_tile_map.level_won.connect(_on_level_won)


##Goes back to lever picker
func _on_exit_level_pressed():
	get_tree().change_scene_to_file(BASE_CUSTOM_PICKER_UID)


## Creates clickable tile buttons
func _create_button(tile_type: TileType.Type) -> PickableTile:
	var tile_coords := TileType.coordinates(tile_type)
	var texture: Texture = load(TileType.texture(tile_type))
	var container = PickableTile.create_scene(tile_coords, texture)
	return container


func _on_next_level_pressed():
	if false: #custom_levels_visible:
		_on_exit_level_pressed()
	else:
		current_level += 1
		level_tile_map.set_level(loaded_base_levels[current_level])


func _on_level_won() -> void:
	var loaded_data = PlayerData.load_default()
	if loaded_data is Error:
		# The extra +1 is because we store levels in save file from level 1 :l
		PlayerData.new().unlock_level(current_level + 1 + 1) # X_X
		return
	(loaded_data as PlayerData).unlock_level(current_level + 1 + 1) # X_X


func _on_retry_pressed():
	level_tile_map.draw_starting_map()


func victory_screen():
	if true: #custom_levels_visible or (current_level != level_picker.max_level()):
		var victory_scene: VictoryScreen = VICTORY_SCREEN.instantiate()
		controls.add_child(victory_scene)
		victory_scene.next_level_requested.connect(_on_next_level_pressed, CONNECT_ONE_SHOT)
		victory_scene.next_level_requested.connect(victory_scene.queue_free, CONNECT_ONE_SHOT)
	else:
		controls.add_child(END_SCREEN.instantiate())


func loser_screen(losing_outputs: Dictionary):
	var loser_scene := LoserScreen.custom_new(losing_outputs)
	controls.add_child(loser_scene)
	loser_scene.retry_requested.connect(_on_retry_pressed, CONNECT_ONE_SHOT)
	loser_scene.retry_requested.connect(loser_scene.queue_free, CONNECT_ONE_SHOT)
