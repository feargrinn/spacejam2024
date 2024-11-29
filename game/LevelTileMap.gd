extends Node2D

class_name LevelTileMap

var number_of_tiles_x: int
var number_of_tiles_y: int
var all_outputs: Array[Vector2i] = []

var current_tile = null;
var left_mouse_was_pressed = false;
var right_mouse_was_pressed = false;
var tile = null
var is_running: bool
var level_name: String

var placing_sounds = []

var background_layer: BackgroundLayer
var tile_colour_layer: ColourLayer
var tile_layer: TileLayer
var tile_hover_layer

var level_data
var color_translation = {}

func _init(level: Level):
	# This name is used by the tile picker.
	name = "map"
	level_data = level
	level_name = level.name
	number_of_tiles_x = level.width
	number_of_tiles_y = level.height
	if max(number_of_tiles_x, number_of_tiles_y) <= 10:
		scale = Vector2(2, 2)
	position = Globals.WINDOW_SIZE / 2 - Vector2(
		number_of_tiles_x * scale.x * Globals.TILE_SIZE / 2,
		number_of_tiles_y * scale.y * Globals.TILE_SIZE / 2
	)



func place_input(input: PreInput):
	tile_layer.place_tile(Vector2i(input.x, input.y), TileId.new(coordinates(TileType.Type.INPUT), input.rot))
	tile_colour_layer.set_tile_colour(Vector2i(input.x, input.y), input.colour, input)


func place_output(output: PreOutput):
	tile_layer.place_tile(Vector2i(output.x, output.y), TileId.new(coordinates(TileType.Type.OUTPUT), output.rot))
	tile_colour_layer.set_tile_colour(Vector2i(output.x, output.y), output.colour, output)

func coordinates(tile_type : TileType.Type):
	return TileType.coordinates(tile_type)

func place_tile(pretile: PreTile):
	# TODO: this is actually wrong, because the enum got renumbered
	tile_layer.place_tile(Vector2i(pretile.x, pretile.y), TileId.new(coordinates(pretile.type), pretile.rot))
	tile_colour_layer.update_at(Vector2i(pretile.x, pretile.y))


func background_description():
	var description = {}
	for i in range(number_of_tiles_x - 2):
		for j in range(number_of_tiles_y - 2):
			description[Vector2i(i + 1, j + 1)] = true
	return description


func create_layers():
	var create_layer = func():
		var layer = TileMapLayer.new()
		layer.tile_set = Globals.TILE_SET
		add_child(layer)
		return layer
	background_layer = BackgroundLayer.new(background_description())
	add_child(background_layer)
	tile_colour_layer = ColourLayer.new()
	add_child(tile_colour_layer)
	tile_layer = TileLayer.new()
	ColourLayer.tile_layer = tile_layer
	add_child(tile_layer)
	tile_hover_layer = create_layer.call()
	tile_hover_layer.modulate.a /= 2
	TileInteractor.hover_layer = tile_hover_layer
	move_child(background_layer, 0)
	move_child(tile_colour_layer, 1)
	move_child(tile_layer, 2)
	move_child(tile_hover_layer, 3)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	is_running = true
	for i in 3:
		placing_sounds.append(AudioStreamPlayer.new())
	placing_sounds[0].stream = preload("res://sfx/sfx_pop_down_tile_1.wav")
	placing_sounds[1].stream = preload("res://sfx/sfx_pop_down_tile_2.wav")
	placing_sounds[2].stream = preload("res://sfx/sfx_pop_down_tile_3.wav")
	for sound in placing_sounds:
		add_child(sound)
	create_layers()
	for input in level_data.inputs:
		place_input(input)
	for output in level_data.outputs:
		place_output(output)
	for other_tile in level_data.tiles:
		place_tile(other_tile)
		
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
			get_node("/root/Game/TileTurning").play()
			tile.rotate()
		
		if Input.is_action_just_pressed("LMB"):
			var tile_position = _mouse_position_to_coordinates()
			if background_layer.is_background(tile_position):
				placing_sounds[RandomNumberGenerator.new().randi_range(0, 2)].play()
				set_tile_at(tile_position)
			tile = null


var losing_outputs: Dictionary

func check_for_game_status():
	if tile_layer.all_outputs().is_empty():
		return
	if not losing_outputs.is_empty():
		get_parent().loser_screen(scale, losing_outputs)
		return
	if tile_layer.all_outputs().any(func(tile_position): return !(tile_colour_layer.get_cell_atlas_coords(tile_position) == coordinates(TileType.Type.OUTPUT_FILLED))):
		return

	is_running = false
	get_parent().victory_screen(scale, tile_layer.all_outputs())
