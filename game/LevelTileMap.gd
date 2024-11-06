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
	#for tile in level.tiles:
		##TODO: doesn't seem to update on placement correctly?
		#place_tile(tile)




# modulating the tile in our TileSetAtlasSource - giving it a colour
# if there ever is a problem with all inputs being of the same colour it's because of that
func create_coloured_tile(coordinates_in_source, alternative_id, new_colour):
	var atlas_source = Globals.TILE_SET.get_source(0)
	var coloured_alternative_id = atlas_source.create_alternative_tile(coordinates_in_source)
	var tile_data = atlas_source.get_tile_data(coordinates_in_source, alternative_id)
	var new_tile_data = atlas_source.get_tile_data(coordinates_in_source, coloured_alternative_id)
	new_tile_data.flip_h = tile_data.flip_h
	new_tile_data.flip_v = tile_data.flip_v
	new_tile_data.transpose = tile_data.transpose
	new_tile_data.modulate = new_colour
	return coloured_alternative_id
	
func place_input(input: PreInput):
	tile_layer.set_cell(Vector2i(input.x, input.y), 0, TileType.INPUT(), input.rot)
	var alternative_id = create_coloured_tile(TileType.INPUT_COLOR(), input.rot, input.colour.color())
	tile_colour_layer.set_cell(Vector2i(input.x, input.y), 0, TileType.INPUT_COLOR(), alternative_id)


func place_output(output: PreOutput):
	tile_layer.set_cell(Vector2i(output.x, output.y), 0, TileType.OUTPUT(), output.rot)
	var alternative_id = create_coloured_tile(TileType.OUTPUT_COLOR(), output.rot, output.colour.color())
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
	for tile in level_data.tiles:
		place_tile(tile)
		
func init_tile_at(tile: Vector2i, ix:int, iy:int, rot: int = 0):
	tile_layer.set_cell(Vector2i(ix, iy), 0, tile, rot)
	
#func set_tile_at(tile:Tile, ix:int, iy:int, rot: int = 0):
	#tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	#remove_child(tiles[ix][iy])
	#init_tile_at(tile, ix, iy, rot)
	#update_at(ix, iy)
	#check_for_game_status()
	
#func _mouse_position_to_coordinates():
	#var game_position = Globals.WINDOW_SIZE / 2 - Vector2(
		#number_of_tiles_x * scale.x * Globals.TILE_SIZE / 2,
		#number_of_tiles_y * scale.y * Globals.TILE_SIZE / 2)
	#var vec = get_global_mouse_position() - game_position
	#vec /= scale[0]
	#var x = (vec[0] )/Globals.TILE_SIZE;
	#var y = (vec[1] )/Globals.TILE_SIZE;
	#return [x,y]

#func register_output(output: OutputTile, x: int, y: int):
	#output.coordinates.x = x
	#output.coordinates.y = y
	#all_outputs.append(output)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#if !is_running:
		#return
		#
	#var game_position = Globals.WINDOW_SIZE / 2 - Vector2(
		#number_of_tiles_x * scale.x * Globals.TILE_SIZE / 2,
		#number_of_tiles_y * scale.y * Globals.TILE_SIZE / 2)
	#if tile != null:
		#if scale[0] != 1:
			#tile.position = (get_global_mouse_position() - game_position)/2
		#else:
			#tile.position = get_global_mouse_position() - position
	#if Input.is_action_just_released("RMB"):
		#if tile != null:
			#tile.player_rotates_right()
	#
	#if Input.is_action_just_pressed("LMB"):
		#if tile != null:
			#var position = _mouse_position_to_coordinates()
			#if (position[0] >= 0 
				#and position[0] < number_of_tiles_x 
				#and position[1] >= 0
				#and position[1] < number_of_tiles_y
				#and tiles[position[0]][position[1]].is_replaceable
			#):
				#placing_sounds[RandomNumberGenerator.new().randi_range(0, 2)].play()
				#remove_child(tile)
				#set_tile_at(tile, position[0], position[1], 0)
				#tile = null
			#else:
				##tile.rotate_right();
				#tile.queue_free()
				#tile = null
	pass

#func update_timestep(to_update: Array[Vector2i]) -> Array[Vector2i]:
	#var update_in_next_step: Array[Vector2i] = []
	#for location in to_update:
		#var x = location.x
		#var y = location.y
		#var tile = tiles[x][y]
		#var empty_neighbours: Array[Vector2i] = []
		#var full_neighbours: Array[Paint] = []
		#for link in tile.links:
			#var offset = Tile.to_vector(link)
			#var other_x = x+offset.x
			#var other_y = y+offset.y
			#var other = tiles[other_x][other_y]
			#if Tile.connected(other, link):
				#if other.is_painted && !other is OutputTile:
					#full_neighbours.append(other.get_paint())
				#else:
					#empty_neighbours.append(Vector2i(other_x, other_y))
		#if full_neighbours.any(func(paint): return paint.amount > 0):
			#var colour = Paint.mix(full_neighbours)
			#tile.set_color(colour)
			## don't update empty anti-tile neighbours
			#if not (tile is AntiTile):
				#update_in_next_step.append_array(empty_neighbours)
	#return update_in_next_step

#func update_at(x: int, y: int):
	#var to_update: Array[Vector2i] = [Vector2i(x, y)]
	#while !to_update.is_empty():
		#to_update = update_timestep(to_update)

#func check_for_game_status():
	#if all_outputs.is_empty():
		#return
#
	#var losing_outputs: Array[OutputTile]
#
	#for output_tile in all_outputs:
		##if output_tile.is_output_filled && !output_tile.color.isEqual(output_tile.target_color):
		#if output_tile.is_output_filled and not output_tile.color.is_similar(output_tile.target_color):
			#is_running = false
			#losing_outputs.append(output_tile)
	#
	#if not losing_outputs.is_empty():
		#get_parent().loser_screen(scale, losing_outputs)
		#return
#
	#if all_outputs.any(func(tile): return !tile.is_output_filled):
		#return
			#
	#is_running = false
	#get_parent().victory_screen(scale, all_outputs)
