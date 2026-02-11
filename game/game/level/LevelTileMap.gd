class_name LevelTileMap
extends Node2D

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

var game: Game

static func dimension_from_background(background: Dictionary) -> Vector2i:
	var max_width = null
	var min_width = null
	var max_height = null
	var min_height = null
	for background_tile in background.keys():
		if max_width == null:
			max_width = background_tile.x
			min_width = background_tile.x
			max_height = background_tile.y
			min_height = background_tile.y
		else:
			max_width = max(max_width, background_tile.x)
			min_width = min(min_width, background_tile.x)
			max_height = max(max_height, background_tile.y)
			min_height = min(min_height, background_tile.y)
	# also add the borders on both sides
	var total_width = max_width - min_width + 1 + 2
	var total_height = max_height - min_height + 1 + 2
	return Vector2i(total_width, total_height)


static func scale_from_dimensions(dimensions: Vector2i) -> Vector2:
	if max(dimensions.x, dimensions.y) <= 10:
		return Vector2(2, 2)
	else:
		return Vector2(1, 1)

func _init(level: Level):
	# This name is used by the tile picker.
	name = "map"
	level_data = level
	level_name = level.name
	
	var dimensions = dimension_from_background(level.background)
	scale = scale_from_dimensions(dimensions)
	position = Globals.WINDOW_SIZE / 2 - Vector2(
		dimensions.x * scale.x * Globals.TILE_SIZE / 2,
		dimensions.y * scale.y * Globals.TILE_SIZE / 2
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
	tile_layer.place_tile(Vector2i(pretile.x, pretile.y), TileId.new(pretile.type, pretile.rot))
	tile_colour_layer.update_at(Vector2i(pretile.x, pretile.y))

func create_layers():
	var create_layer = func():
		var layer = TileMapLayer.new()
		layer.tile_set = Globals.TILE_SET
		add_child(layer)
		return layer
	background_layer = BackgroundLayer.new(level_data.background)
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
	game = get_node("/root/Game")
	is_running = true
	for i in 3:
		placing_sounds.append(AudioStreamPlayer.new())
	placing_sounds[0].stream = preload("res://game/shared/sfx/sfx_pop_down_tile_1.wav")
	placing_sounds[1].stream = preload("res://game/shared/sfx/sfx_pop_down_tile_2.wav")
	placing_sounds[2].stream = preload("res://game/shared/sfx/sfx_pop_down_tile_3.wav")
	for sound in placing_sounds:
		add_child(sound)
	set_starting_map()

func set_starting_map():
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
			Sounds.play("turning")
			tile.rotate()
		
		if Input.is_action_just_pressed("LMB"):
			var tile_position = _mouse_position_to_coordinates()
			if background_layer.is_background(tile_position):
				placing_sounds[RandomNumberGenerator.new().randi_range(0, 2)].play()
				set_tile_at(tile_position)
			tile = null


var losing_outputs: Dictionary[Vector2i, Dictionary]


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
