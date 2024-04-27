extends Sprite2D

class_name Map

const empty_tile_script = preload("res://Tiles/EmptyTile.gd")
const no_tile_script = preload("res://Tiles/NoTile.gd")
const t_tile_script = preload("res://Tiles/TTile.gd")
const straight_tile_script = preload("res://Tiles/StraightTile.gd")
const bend_tile_script = preload("res://Tiles/LTile.gd")
const colour_script = preload("res://Colour.gd")
const input_script = preload("res://Tiles/InputTile.gd")

var tiles = []
var number_of_tiles: int

var current_tile = null;
var left_mouse_was_pressed = false;
var right_mouse_was_pressed = false;
var tile = null;

func fill_map():
	number_of_tiles = 20
	for i in range(number_of_tiles):
		var tilesRow = []
		for j in range(number_of_tiles):
			tilesRow.append(empty_tile_script.new())

		tiles.append(tilesRow)

	for i in range(number_of_tiles):
		for j in range(number_of_tiles):
			init_tile_at(tiles[i][j], i, j)

func level_definition():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	fill_map()
	level_definition()
	add_edges()
	
func init_tile_at(tile:Tile, ix:int, iy:int, rot: int = 0):
	tiles[ix][iy] = tile
	add_child(tile)
	tile.position = position + Vector2(
		(ix + 0.5) * Globals.TILE_SIZE,
		(iy + 0.5) * Globals.TILE_SIZE
	)
	for i in range(rot):
		tile.rotate_right()
	
func set_tile_at(tile:Tile, ix:int, iy:int, rot: int = 0):
	remove_child(tiles[ix][iy])
	init_tile_at(tile, ix, iy, rot)
	
func _mouse_position_to_coordinates():
	#tile.position = position + Vector2(
	#	(ix + 0.5) * Globals.TILE_SIZE,
	#	(iy + 0.5) * Globals.TILE_SIZE
	#)
	var vec = get_global_mouse_position() - position
	var x = vec[0]/Globals.TILE_SIZE;
	var y = vec[1]/Globals.TILE_SIZE;
	return [x,y]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and left_mouse_was_pressed and tile != null:
		tile.position = get_global_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and right_mouse_was_pressed == false and tile != null:
		right_mouse_was_pressed = true;
		tile.rotate_right()
	if Input.is_action_just_released("RMB"):
		right_mouse_was_pressed = false
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and left_mouse_was_pressed == false:
		left_mouse_was_pressed = true
		print(current_tile)
		match current_tile:
			null:
				pass
			1:
				tile = StraightTile.new()
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
			3:
				tile = BendTile.new()
				tile.position = get_global_mouse_position()
				add_child(tile)
	
	if Input.is_action_just_released("LMB"):
		left_mouse_was_pressed = false
		if tile != null:
			var position = _mouse_position_to_coordinates()
			remove_child(tile)
			if position[0] >= 0 and position[0] < 20 and position[1] >= 0 and position[1] < 20:
				set_tile_at(tile, position[0], position[1], 0);
			tile = null;
	pass
	
func update_at(x: int, y: int):
	var empty_neighbours = []
	var full_neighbours = []
	var tile = tiles[x][y]
	for link in tile.links:
		var offset = Tile.to_vector(link)
		var other_x = x+offset.x
		var other_y = y+offset.y
		var other = tiles[other_x][other_y]
		if Tile.connected(other, link):
			if other.is_painted:
				full_neighbours.append(other.get_paint())
			else:
				empty_neighbours.append(Vector2i(other_x, other_y))
	if full_neighbours.lenght() > 0:
		var colour = Paint.mix(full_neighbours)
		tile.set_color(colour)
		for neighbour in empty_neighbours:
			fill_pipes(neighbour, colour)

func fill_pipes(coords: Vector2i, colour: Colour):
	var x = coords.x
	var y = coords.y
	var tile = tiles[x][y]
	tile.set_color(colour)
	for link in tile.links:
		var offset = Tile.to_vector(link)
		fill_pipes(tiles[x+offset.x][y+offset.y], colour)

func add_edges():
	var edge: Sprite2D
	for i in range(1, number_of_tiles - 1):
		
		edge = Sprite2D.new()
		edge.texture = preload("res://images/tile_24x24_frame_right.png")
		tiles[0][i].add_child(edge)
		
		edge = Sprite2D.new()
		edge.texture = preload("res://images/tile_24x24_frame_left.png")
		tiles[number_of_tiles-1][i].add_child(edge)
		
		edge = Sprite2D.new()
		edge.texture = preload("res://images/tile_24x24_frame_bottom.png")
		tiles[i][0].add_child(edge)
		
		edge = Sprite2D.new()
		edge.texture = preload("res://images/tile_24x24_frame_top.png")
		tiles[i][number_of_tiles-1].add_child(edge)
	
	edge = Sprite2D.new()
	edge.z_index = 1
	edge.texture = preload("res://images/tile_24x24_frame_corner_bottom_right.png")
	tiles[0][0].add_child(edge)

	edge = Sprite2D.new()
	edge.z_index = 1
	edge.texture = preload("res://images/tile_24x24_frame_corner_bottom_left.png")
	tiles[number_of_tiles-1][0].add_child(edge)

	edge = Sprite2D.new()
	edge.z_index = 1
	edge.texture = preload("res://images/tile_24x24_frame_corner_top_left.png")
	tiles[number_of_tiles-1][number_of_tiles-1].add_child(edge)

	edge = Sprite2D.new()
	edge.z_index = 1
	edge.texture = preload("res://images/tile_24x24_frame_corner_top_right.png")
	tiles[0][number_of_tiles-1].add_child(edge)
