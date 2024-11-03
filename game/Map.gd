extends Sprite2D

class_name Map

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
var all_outputs: Array[OutputTile] = []

var current_tile = null;
var left_mouse_was_pressed = false;
var right_mouse_was_pressed = false;
var tile = null;
var is_running: bool
var level_name: String

var placing_sounds = []
var color_sounds = []

func _init(level: Level):
	# This name is used by the tile picker.
	name = "map"
	level_name = level.name
	number_of_tiles_x = level.width
	number_of_tiles_y = level.height
	if max(number_of_tiles_x, number_of_tiles_y) <= 10:
		scale = Vector2(2, 2)
	position = Globals.WINDOW_SIZE / 2 - Vector2(
		number_of_tiles_x * scale.x * Globals.TILE_SIZE / 2,
		number_of_tiles_y * scale.y * Globals.TILE_SIZE / 2
	)
	fill_map()
	for input in level.inputs:
		place_input(input)
	for output in level.outputs:
		place_output(output)
	for tile in level.tiles:
		#TODO: doesn't seem to update on placement correctly?
		place_tile(tile)

func place_input(input: PreInput):
	var tile = InputTile.new(input.colour)
	set_tile_at(tile, input.x, input.y, input.rot)

func place_output(output: PreOutput):
	var tile = OutputTile.new(output.colour)
	set_tile_at(tile, output.x, output.y, output.rot)
	register_output(tile, output.x, output.y)

func place_tile(pretile: PreTile):
	var tile
	match pretile.type:
		PreTile.TileType.STRAIGHT:
			tile = StraightTile.new()
		PreTile.TileType.T:
			tile = TTile.new()
		PreTile.TileType.L:
			tile = LTile.new()
		PreTile.TileType.CROSS:
			tile = CrossTile.new()
		PreTile.TileType.ANTI:
			tile = AntiTile.new()
	set_tile_at(tile, pretile.x, pretile.y, pretile.rot)


func fill_map():
	for i in range(number_of_tiles_x):
		var tilesRow = []
		for j in range(number_of_tiles_y):
			tilesRow.append(empty_tile_script.new())

		tiles.append(tilesRow)

	for i in range(number_of_tiles_x):
		for j in range(number_of_tiles_y):
			init_tile_at(tiles[i][j], i, j)
			
	for i in range(1, number_of_tiles_x - 1):
		set_tile_at(no_tile_script.new(preload("res://images/tile_24x24_frame_bottom.png")), i, 0)
		set_tile_at(no_tile_script.new(preload("res://images/tile_24x24_frame_top.png")), i, number_of_tiles_y-1)

	for i in range(1, number_of_tiles_y - 1):
		set_tile_at(no_tile_script.new(preload("res://images/tile_24x24_frame_right.png")), 0, i)
		set_tile_at(no_tile_script.new(preload("res://images/tile_24x24_frame_left.png")), number_of_tiles_x-1, i)
	
	set_tile_at(no_tile_script.new(preload("res://images/tile_24x24_frame_corner_bottom_right.png")), 0, 0)
	set_tile_at(no_tile_script.new(preload("res://images/tile_24x24_frame_corner_bottom_left.png")), number_of_tiles_x-1, 0)
	set_tile_at(no_tile_script.new(preload("res://images/tile_24x24_frame_corner_top_left.png")), number_of_tiles_x-1, number_of_tiles_y-1)
	set_tile_at(no_tile_script.new(preload("res://images/tile_24x24_frame_corner_top_right.png")), 0, number_of_tiles_y-1)

# Called when the node enters the scene tree for the first time.
func _ready():
	is_running = true
	for i in 3:
		placing_sounds.append(AudioStreamPlayer.new())
		color_sounds.append(AudioStreamPlayer.new())
	placing_sounds[0].stream = preload("res://sfx/sfx_pop_down_tile_1.wav")
	placing_sounds[1].stream = preload("res://sfx/sfx_pop_down_tile_2.wav")
	placing_sounds[2].stream = preload("res://sfx/sfx_pop_down_tile_3.wav")
	color_sounds[0].stream = preload("res://sfx/pat1.wav")
	color_sounds[1].stream = preload("res://sfx/pat2.wav")
	color_sounds[2].stream = preload("res://sfx/pat3.wav")
	for sound in placing_sounds:
		add_child(sound)
	for sound in color_sounds:
		add_child(sound)
	color_sounds[0].bus = &"Red"
	color_sounds[1].bus = &"Yellow"
	color_sounds[2].bus = &"Blue"
	#print(color_sounds[0].bus)
	#print(color_sounds[1].bus)
	#print(color_sounds[2].bus)
	
func init_tile_at(tile:Tile, ix:int, iy:int, rot: int = 0):
	tiles[ix][iy] = tile
	add_child(tile)
	tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	tile.position = Vector2(
		ix * Globals.TILE_SIZE + Globals.TILE_SIZE / 2,
		iy * Globals.TILE_SIZE + Globals.TILE_SIZE / 2 
	)
	for i in range(rot):
		tile._rotate_right()
	
func set_tile_at(tile:Tile, ix:int, iy:int, rot: int = 0):
	tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	remove_child(tiles[ix][iy])
	init_tile_at(tile, ix, iy, rot)
	update_at(ix, iy)
	check_for_game_status()
	
func _mouse_position_to_coordinates():
	var game_position = Globals.WINDOW_SIZE / 2 - Vector2(
		number_of_tiles_x * scale.x * Globals.TILE_SIZE / 2,
		number_of_tiles_y * scale.y * Globals.TILE_SIZE / 2)
	var vec = get_global_mouse_position() - game_position
	vec /= scale[0]
	var x = (vec[0] )/Globals.TILE_SIZE;
	var y = (vec[1] )/Globals.TILE_SIZE;
	return [x,y]

func register_output(output: OutputTile, x: int, y: int):
	output.coordinates.x = x
	output.coordinates.y = y
	all_outputs.append(output)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !is_running:
		return
		
	var game_position = Globals.WINDOW_SIZE / 2 - Vector2(
		number_of_tiles_x * scale.x * Globals.TILE_SIZE / 2,
		number_of_tiles_y * scale.y * Globals.TILE_SIZE / 2)
	if tile != null:
		if scale[0] != 1:
			tile.position = (get_global_mouse_position() - game_position)/2
		else:
			tile.position = get_global_mouse_position() - position
	if Input.is_action_just_released("RMB"):
		if tile != null:
			tile.player_rotates_right()
	
	if Input.is_action_just_pressed("LMB"):
		if tile != null:
			var position = _mouse_position_to_coordinates()
			if (position[0] >= 0 
				and position[0] < number_of_tiles_x 
				and position[1] >= 0
				and position[1] < number_of_tiles_y
				and tiles[position[0]][position[1]].is_replaceable
			):
				placing_sounds[RandomNumberGenerator.new().randi_range(0, 2)].play()
				remove_child(tile)
				set_tile_at(tile, position[0], position[1], 0)
				tile = null
			else:
				#tile.rotate_right();
				tile.queue_free()
				tile = null
	pass

func update_timestep(to_update: Array[Vector2i]) -> Array[Vector2i]:
	var update_in_next_step: Array[Vector2i] = []
	for location in to_update:
		var x = location.x
		var y = location.y
		var tile = tiles[x][y]
		var empty_neighbours: Array[Vector2i] = []
		var full_neighbours: Array[Paint] = []
		for link in tile.links:
			var offset = Tile.to_vector(link)
			var other_x = x+offset.x
			var other_y = y+offset.y
			var other = tiles[other_x][other_y]
			if Tile.connected(other, link):
				if other.is_painted && !other is OutputTile:
					full_neighbours.append(other.get_paint())
				else:
					empty_neighbours.append(Vector2i(other_x, other_y))
		if full_neighbours.any(func(paint): return paint.amount > 0):
			var colour = Paint.mix(full_neighbours)
			tile.set_color(colour)
			# color sounds
			var pitch_shift_r = AudioServer.get_bus_effect(1, 0)
			var pitch_shift_y = AudioServer.get_bus_effect(2, 0)
			var pitch_shift_b = AudioServer.get_bus_effect(3, 0)
			print(AudioServer.get_bus_effect(1, 0))
			print(AudioServer.get_bus_effect(2, 0))
			print(AudioServer.get_bus_effect(3, 0))
			var scale_upper_limit = 8.0
			var scale_lower_limit = 0.5
			var scale_range = scale_upper_limit - scale_lower_limit
			# applies pitch shift per color to audio buses and plays sounds
			pitch_shift_r.pitch_scale = colour.r * scale_range + scale_lower_limit
			color_sounds[0].play()
			pitch_shift_y.pitch_scale = colour.y * scale_range + scale_lower_limit
			color_sounds[1].play()
			pitch_shift_b.pitch_scale = colour.b * scale_range + scale_lower_limit
			color_sounds[2].play()
			# doesnt work stlil... takes same pitch shifter instance for some reason
			# don't update empty anti-tile neighbours
			if not (tile is AntiTile):
				update_in_next_step.append_array(empty_neighbours)
	return update_in_next_step

func update_at(x: int, y: int):
	var to_update: Array[Vector2i] = [Vector2i(x, y)]
	while !to_update.is_empty():
		to_update = update_timestep(to_update)

func check_for_game_status():
	if all_outputs.is_empty():
		return

	var losing_outputs: Array[OutputTile]

	for output_tile in all_outputs:
		#if output_tile.is_output_filled && !output_tile.color.isEqual(output_tile.target_color):
		if output_tile.is_output_filled and not output_tile.color.is_similar(output_tile.target_color):
			is_running = false
			losing_outputs.append(output_tile)
	
	if not losing_outputs.is_empty():
		get_parent().loser_screen(scale, losing_outputs)
		return

	if all_outputs.any(func(tile): return !tile.is_output_filled):
		return
			
	is_running = false
	get_parent().victory_screen(scale, all_outputs)
