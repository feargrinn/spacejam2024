extends Sprite2D

class_name LevelTileMap

const empty_tile_script = preload("res://Tiles/EmptyTile.gd")
const no_tile_script = preload("res://Tiles/NoTile.gd")
const t_tile_script = preload("res://Tiles/TTile.gd")
const straight_tile_script = preload("res://Tiles/StraightTile.gd")
const bend_tile_script = preload("res://Tiles/LTile.gd")
const anti_tile_script = preload("res://Tiles/AntiTile.gd")
const colour_script = preload("res://Colour.gd")
const input_script = preload("res://Tiles/InputTile.gd")
const output_script = preload("res://Tiles/OutputTile.gd")

var tiles = []
var number_of_tiles_x: int
var number_of_tiles_y: int
#var all_outputs: Array[OutputTile] = []
var all_outputs: Array[Vector2i] = []

var current_tile = null;
var left_mouse_was_pressed = false;
var right_mouse_was_pressed = false;
var tile = null;
var is_running: bool
var level_name: String

var placing_sounds = []

var background_layer : TileMapLayer
var tile_colour_layer
var tile_layer
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
	tile_layer.set_cell(Vector2i(input.x, input.y), 0, TileType.INPUT(), input.rot)
	var alternative_id = Colour.create_coloured_tile(TileType.INPUT_COLOR(), input.rot, input.colour.color())
	color_translation[input.colour.color()] = input.colour
	tile_colour_layer.set_cell(Vector2i(input.x, input.y), 0, TileType.INPUT_COLOR(), alternative_id)


func place_output(output: PreOutput):
	tile_layer.set_cell(Vector2i(output.x, output.y), 0, TileType.OUTPUT(), output.rot)
	var alternative_id = Colour.create_coloured_tile(TileType.OUTPUT_COLOR(), output.rot, output.colour.color())
	color_translation[output.colour.color()] = output.colour
	tile_colour_layer.set_cell(Vector2i(output.x, output.y), 0, TileType.OUTPUT_COLOR(), alternative_id)
	#register_output(tile, output.x, output.y)
	all_outputs.append(Vector2i(output.x, output.y))

func place_tile(pretile: PreTile):
	match pretile.type:
		PreTile.TileTypeEnum.STRAIGHT:
			tile_layer.set_cell(Vector2i(pretile.x, pretile.y), 0, TileType.STRAIGHT(), pretile.rot)
		PreTile.TileTypeEnum.T:
			tile_layer.set_cell(Vector2i(pretile.x, pretile.y), 0, TileType.T(), pretile.rot)
		PreTile.TileTypeEnum.L:
			tile_layer.set_cell(Vector2i(pretile.x, pretile.y), 0, TileType.L(), pretile.rot)
		PreTile.TileTypeEnum.CROSS:
			tile_layer.set_cell(Vector2i(pretile.x, pretile.y), 0, TileType.CROSS(), pretile.rot)
		PreTile.TileTypeEnum.ANTI:
			tile_layer.set_cell(Vector2i(pretile.x, pretile.y), 0, TileType.ANTI(), pretile.rot)
	update_at(Vector2i(pretile.x, pretile.y))


func fill_map():
	for i in range(number_of_tiles_x - 2):
		for j in range(number_of_tiles_y - 2):
			background_layer.set_cell(Vector2i(i + 1, j + 1), 0, Vector2i(0,0))
			BorderHandler.update_surrounding_background(background_layer, Vector2i(i + 1, j + 1))


func create_layers():
	var create_layer = func():
		var layer = TileMapLayer.new()
		layer.tile_set = Globals.TILE_SET
		add_child(layer)
		return layer
	background_layer = create_layer.call()
	tile_colour_layer = create_layer.call()
	tile_layer = create_layer.call()
	tile_hover_layer = create_layer.call()
	tile_hover_layer.modulate.a /= 2
	

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
	fill_map()
	for input in level_data.inputs:
		place_input(input)
	for output in level_data.outputs:
		place_output(output)
	for other_tile in level_data.tiles:
		place_tile(other_tile)
		
func init_tile_at(tiletype: Vector2i, ix:int, iy:int, rot: int = 0):
	tile_layer.set_cell(Vector2i(ix, iy), 0, tiletype, rot)
	
func set_tile_at(tile_position):
	tile_layer.set_cell(tile_position, 0, tile[0], tile[1])
	update_at(tile_position)
	check_for_game_status()
	
func _mouse_position_to_coordinates():
	return background_layer.local_to_map(get_local_mouse_position())

#func register_output(output: OutputTile, x: int, y: int):
	#output.coordinates.x = x
	#output.coordinates.y = y
	#all_outputs.append(output)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !is_running:
		return

	tile_hover_layer.clear()
	if tile != null:
		tile_hover_layer.set_cell(_mouse_position_to_coordinates(), 0, tile[0], tile[1])
	if Input.is_action_just_released("RMB"):
		if tile != null:
			get_node("/root/Game/TileTurning").play()
			tile[1] += 1
			if !Globals.TILE_SET.get_source(0).has_alternative_tile(tile[0],tile[1]):
				tile[1] = 0
	
	if Input.is_action_just_pressed("LMB"):
		if tile != null:
			var tile_position = _mouse_position_to_coordinates()
			if background_layer.get_cell_atlas_coords(tile_position) == TileType.BACKGROUND():
				placing_sounds[RandomNumberGenerator.new().randi_range(0, 2)].play()
				set_tile_at(tile_position)
			tile = null

func get_possible_connections(tile_position):
	if tile_layer.get_cell_atlas_coords(tile_position) == TileType.EMPTY():
		return []
	var check_direction = func(direction_name):
		return tile_layer.get_cell_tile_data(tile_position).get_custom_data(direction_name)
	var connections = []
	if check_direction.call("UP"):
		connections.append(Vector2i.UP)
	if check_direction.call("RIGHT"):
		connections.append(Vector2i.RIGHT)
	if check_direction.call("DOWN"):
		connections.append(Vector2i.DOWN)
	if check_direction.call("LEFT"):
		connections.append(Vector2i.LEFT)
	return connections

func connects_back(tile_position, vector_to_this):
	return get_possible_connections(tile_position).has(vector_to_this * -1)

func is_painted(tile_position):
	if tile_colour_layer.get_cell_atlas_coords(tile_position) != TileType.EMPTY():
		return true
	return false

func get_tile_colour(tile_position):
	var position_in_atlas = tile_colour_layer.get_cell_atlas_coords(tile_position)
	var alternative_id = tile_colour_layer.get_cell_alternative_tile(tile_position)
	var atlas_source = Globals.TILE_SET.get_source(0)
	var tile_data = atlas_source.get_tile_data(position_in_atlas, alternative_id)
	return color_translation[tile_data.modulate]

var losing_outputs: Array[Vector2i] = []

func update_timestep(to_update: Array[Vector2i]) -> Array[Vector2i]:
	var update_in_next_step: Array[Vector2i] = []
	for location in to_update:
		var tile_connections = get_possible_connections(location)
		var empty_neighbours: Array[Vector2i] = []
		var full_neighbours: Array[Paint] = []
		for link in tile_connections:
			var other = location + link
			if connects_back(other, link):
				if is_painted(other) && tile_layer.get_cell_atlas_coords(other) != TileType.OUTPUT():
					full_neighbours.append(Paint.new(get_tile_colour(other),1.))
				else:
					empty_neighbours.append(other)
		if full_neighbours.any(func(paint): return paint.amount > 0):
			var colour = Paint.mix(full_neighbours)
			color_translation[colour.color()] = colour
			if tile_layer.get_cell_atlas_coords(location) == TileType.OUTPUT():
				var alternative_id = Colour.create_coloured_tile(TileType.OUTPUT_FILLED(), tile_layer.get_cell_alternative_tile(location), colour.color())
				var target_colour = get_tile_colour(location)
				tile_colour_layer.set_cell(location, 0, TileType.OUTPUT_FILLED(), alternative_id)
				var filling_colour = get_tile_colour(location)
				if !target_colour.is_similar(filling_colour):
					losing_outputs.append(location)
					is_running = false
			else:
				var alternative_id = Colour.create_coloured_tile(TileType.COLOR(), 0, colour.color())
				tile_colour_layer.set_cell(location, 0, TileType.COLOR(), alternative_id)
			## don't update empty anti-tile neighbours
			if tile_layer.get_cell_atlas_coords(location) != TileType.ANTI():
				update_in_next_step.append_array(empty_neighbours)
	return update_in_next_step

func update_at(pos : Vector2i):
	var to_update: Array[Vector2i] = [pos]
	while !to_update.is_empty():
		to_update = update_timestep(to_update)


func check_for_game_status():
	if all_outputs.is_empty():
		return
#
	#var losing_outputs: Array[Vector2i]
#
	#for output_tile in all_outputs:
		##if output_tile.is_output_filled && !output_tile.color.isEqual(output_tile.target_color):
		#if output_tile.is_output_filled and not output_tile.color.is_similar(output_tile.target_color):
			#is_running = false
			#losing_outputs.append(output_tile)
	#
	if not losing_outputs.is_empty():
		get_parent().loser_screen(scale, losing_outputs)
		return


	if all_outputs.any(func(tile_position): return !(tile_colour_layer.get_cell_atlas_coords(tile_position) == TileType.OUTPUT_FILLED())):
		return

	is_running = false
	get_parent().victory_screen(scale, all_outputs)
