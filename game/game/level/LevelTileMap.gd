class_name LevelTileMap
extends Node2D

const LEVEL_TILE_MAP = preload("uid://dys1pp7uead78")

var all_outputs: Array[Vector2i] = []

var current_tile = null;
var tile = null
var is_running: bool
var level_name: String

# The stream player still shouldn't be here I think, but it's better
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var background_layer: BackgroundLayer
@export var tile_colour_layer: ColourLayer
@export var tile_layer: TileLayer
@export var tile_hover_layer: TileMapLayer

var level_data: Level
var color_translation = {}

var game: Game

var losing_outputs: Dictionary[Vector2i, Dictionary]


static func custom_new(level: Level) -> LevelTileMap:
	var tilemap: LevelTileMap = LEVEL_TILE_MAP.instantiate()
	tilemap.level_data = level
	tilemap.level_name = level.name
	return tilemap


# Called when the node enters the scene tree for the first time.
func _ready():
	background_layer.background = level_data.background
	
	game = get_node("/root/Game")
	is_running = true
	
	set_starting_map()


func scale_from_dimensions(dimensions: Vector2i) -> Vector2:
	if max(dimensions.x, dimensions.y) <= 10:
		return Vector2(2, 2)
	else:
		return Vector2(1, 1)


func place_input(input: PreInput):
	tile_layer.place_tile(Vector2i(input.x, input.y), TileId.new(coordinates(TileType.Type.INPUT), input.rot))
	tile_colour_layer.set_tile_colour(Vector2i(input.x, input.y), input.colour, input)


func place_output(output: PreOutput):
	tile_layer.place_tile(Vector2i(output.x, output.y), TileId.new(coordinates(TileType.Type.OUTPUT), output.rot))
	tile_colour_layer.set_tile_colour(Vector2i(output.x, output.y), output.colour, output)

func coordinates(tile_type : TileType.Type):
	return TileType.coordinates(tile_type)

func place_tile(pretile: PreTile):
	tile_layer.place_tile(Vector2i(pretile.x, pretile.y), TileId.new(pretile.type, pretile.rot))
	tile_colour_layer.update_at(Vector2i(pretile.x, pretile.y))


func set_starting_map():
	TileInteractor.hover_layer = tile_hover_layer
	for input in level_data.inputs:
		place_input(input)
	for output in level_data.outputs:
		place_output(output)
	for other_tile in level_data.tiles:
		place_tile(other_tile)
	
	var dimensions := background_layer.get_used_rect().size
	scale = scale_from_dimensions(dimensions)
	position = Globals.WINDOW_SIZE / 2 - Vector2(
		dimensions.x * scale.x * Globals.TILE_SIZE / 2,
		dimensions.y * scale.y * Globals.TILE_SIZE / 2
	)


func set_tile_at(tile_position):
	tile_layer.place_tile(tile_position, tile)
	tile_colour_layer.update_at(tile_position)
	check_for_game_status()
	
func _mouse_position_to_coordinates():
	return background_layer.local_to_map(get_local_mouse_position())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !is_running:
		return

	if(tile != null):tile_hover_layer.clear()
	if tile != null:
		tile_hover_layer.set_cell(_mouse_position_to_coordinates(), 0, tile.id, tile.alternative)
		if Input.is_action_just_released("RMB"):
			Sounds.play("turning")
			tile.rotate()
		
		if Input.is_action_just_pressed("LMB"):
			var tile_position = _mouse_position_to_coordinates()
			if background_layer.is_background(tile_position):
				audio_stream_player.play()
				set_tile_at(tile_position)
			tile = null




func animate_outputs(outputs: Array[Vector2i], animation_name: String) -> void:
	Sounds.play(animation_name)
	
	var animated_tiles: Array[AnimatedTile] = []
	for output in outputs:
		var a_tile := AnimatedTile.custom_new(tile_layer, animation_name, output)
		animated_tiles.append(a_tile)
	
	match(animation_name):
		"winning":
			animated_tiles[0].animation_finished.connect(game.victory_screen)
		"losing":
			animated_tiles[0].animation_finished.connect(game.loser_screen.bind(losing_outputs))


func is_output_filled(tile_coords: Vector2i) -> bool:
	var atlas_coords := tile_colour_layer.get_cell_atlas_coords(tile_coords)
	return atlas_coords == coordinates(TileType.Type.OUTPUT_FILLED)


func all_outputs_filled(outputs: Array[Vector2i]) -> bool:
	for output in outputs:
		if !is_output_filled(output):
			return false
	return true


func check_for_game_status():
	if not losing_outputs.is_empty():
		animate_outputs(losing_outputs.keys(), "losing")
		return
	
	if !all_outputs_filled(tile_layer.all_outputs()):
		return
	
	is_running = false
	
	animate_outputs(tile_layer.all_outputs(), "winning")
