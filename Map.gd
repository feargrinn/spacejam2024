extends Sprite2D

class_name Map

const empty_tile_script = preload("res://Tiles/EmptyTile.gd")
const no_tile_script = preload("res://Tiles/NoTile.gd")
const t_tile_script = preload("res://Tiles/TTile.gd")
const straight_tile_script = preload("res://Tiles/StraightTile.gd")
const bend_tile_script = preload("res://Tiles/LTile.gd")
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

func set_dimensions():
	pass

func level_definition():
	pass

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
		set_tile_at(no_tile_script.new(), i, 0)
		set_tile_at(no_tile_script.new(), i, number_of_tiles_y-1)

	for i in range(1, number_of_tiles_y - 1):
		set_tile_at(no_tile_script.new(), 0, i)
		set_tile_at(no_tile_script.new(), number_of_tiles_x-1, i)
	
	set_tile_at(no_tile_script.new(), 0, 0)
	set_tile_at(no_tile_script.new(), number_of_tiles_x-1, 0)
	set_tile_at(no_tile_script.new(), number_of_tiles_x-1, number_of_tiles_y-1)
	set_tile_at(no_tile_script.new(), 0, number_of_tiles_y-1)

func prepare_map():
	set_dimensions()
	if max(number_of_tiles_x, number_of_tiles_y) <= 10:
		scale = Vector2(2, 2)
	
	position += Globals.WINDOW_SIZE / 2 - Vector2(
		number_of_tiles_x * scale.x * Globals.TILE_SIZE / 2,
		number_of_tiles_y * scale.y * Globals.TILE_SIZE / 2
	)

# Called when the node enters the scene tree for the first time.
func _ready():
	prepare_map()
	fill_map()
	level_definition()
	add_edges()
	
func init_tile_at(tile:Tile, ix:int, iy:int, rot: int = 0):
	tiles[ix][iy] = tile
	add_child(tile)
	tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	tile.position = Vector2(
		ix * Globals.TILE_SIZE + Globals.TILE_SIZE / 2,
		iy * Globals.TILE_SIZE + Globals.TILE_SIZE / 2 
	)
	for i in range(rot):
		tile.rotate_right()
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var game_position = Globals.WINDOW_SIZE / 2 - Vector2(
		number_of_tiles_x * scale.x * Globals.TILE_SIZE / 2,
		number_of_tiles_y * scale.y * Globals.TILE_SIZE / 2)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and left_mouse_was_pressed and tile != null:
		if scale[0] != 1:
			tile.position = (get_global_mouse_position() - game_position)/2
		else:
			tile.position = get_global_mouse_position() - position
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and right_mouse_was_pressed == false and tile != null:
		right_mouse_was_pressed = true;
		tile.rotate_right()
	if Input.is_action_just_released("RMB"):
		right_mouse_was_pressed = false
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and left_mouse_was_pressed == false:
		left_mouse_was_pressed = true
		match current_tile:
			null:
				pass
			1:
				tile = ITile.new()
				tile.position = get_global_mouse_position()
				add_child(tile)
			2:
				tile = TTile.new()
				tile.position = get_global_mouse_position()
				add_child(tile)
			3:
				tile = BendTile.new()
				tile.position = get_global_mouse_position()
				add_child(tile)
			4:
				tile = CrossTile.new()
				tile.position = get_global_mouse_position()
				add_child(tile)
	
	if Input.is_action_just_released("LMB"):
		left_mouse_was_pressed = false
		if tile != null:
			var position = _mouse_position_to_coordinates()
			remove_child(tile)
			if position[0] >= 0 and position[0] < number_of_tiles_x and position[1] >= 0 and position[1] < number_of_tiles_y:
				set_tile_at(tile, position[0], position[1], 0);
			tile = null;
	pass
	
func update_at(x: int, y: int):
	var empty_neighbours = []
	var full_neighbours: Array[Paint] = []
	var tile = tiles[x][y]
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
	if !full_neighbours.is_empty():
		var colour = Paint.mix(full_neighbours)
		tile.set_color(colour)
		if tile is OutputTile:
			tile.texture = preload("res://images/tile_24x24_output_transparent.png")
			tile.is_output_filled = true
		for neighbour in empty_neighbours:
			fill_pipes(neighbour, colour)

func fill_pipes(coords: Vector2i, colour: Colour):
	var x = coords.x
	var y = coords.y
	var tile = tiles[x][y]
	if tile.is_painted && !tile is OutputTile:
		return

	tile.set_color(colour)
	if tile is OutputTile:
		tile.texture = preload("res://images/tile_24x24_output_transparent.png")
		tile.is_output_filled = true

	for link in tile.links:
		var offset = Tile.to_vector(link)
		fill_pipes(Vector2i(x+offset.x, y+offset.y), colour)

func add_edges():
	var edge: Sprite2D
	for i in range(1, number_of_tiles_y - 1):
		
		edge = Sprite2D.new()
		edge.texture = preload("res://images/tile_24x24_frame_right.png")
		tiles[0][i].add_child(edge)
		
		edge = Sprite2D.new()
		edge.texture = preload("res://images/tile_24x24_frame_left.png")
		tiles[number_of_tiles_x-1][i].add_child(edge)
		
	for i in range(1, number_of_tiles_x - 1):
		edge = Sprite2D.new()
		edge.texture = preload("res://images/tile_24x24_frame_bottom.png")
		tiles[i][0].add_child(edge)
		
		edge = Sprite2D.new()
		edge.texture = preload("res://images/tile_24x24_frame_top.png")
		tiles[i][number_of_tiles_y-1].add_child(edge)
	
	edge = Sprite2D.new()
	edge.z_index = 1
	edge.texture = preload("res://images/tile_24x24_frame_corner_bottom_right.png")
	tiles[0][0].add_child(edge)

	edge = Sprite2D.new()
	edge.z_index = 1
	edge.texture = preload("res://images/tile_24x24_frame_corner_bottom_left.png")
	tiles[number_of_tiles_x-1][0].add_child(edge)

	edge = Sprite2D.new()
	edge.z_index = 1
	edge.texture = preload("res://images/tile_24x24_frame_corner_top_left.png")
	tiles[number_of_tiles_x-1][number_of_tiles_y-1].add_child(edge)

	edge = Sprite2D.new()
	edge.z_index = 1
	edge.texture = preload("res://images/tile_24x24_frame_corner_top_right.png")
	tiles[0][number_of_tiles_y-1].add_child(edge)

func check_for_game_status():
	if all_outputs.is_empty():
		return

	for output_tile in all_outputs:
		if output_tile.is_output_filled && !output_tile.color.isEqual(output_tile.target_color):
			print("LOST")

	for output_tile in all_outputs:
		if !output_tile.is_output_filled:
			return
			
	get_parent().get_node("ColorRect").show()
