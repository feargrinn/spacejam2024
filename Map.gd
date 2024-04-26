extends Sprite2D

const empty_tile_script = preload("res://Tiles/EmptyTile.gd")
const t_tile_script = preload("res://Tiles/TTile.gd")
const straight_tile_script = preload("res://Tiles/StraightTile.gd")
const bend_tile_script = preload("res://Tiles/LTile.gd")
const colour_script = preload("res://Colour.gd")

var tiles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(20):
		var tilesRow = []
		for j in range(20):
			tilesRow.append(empty_tile_script.new())

		tiles.append(tilesRow)

	for i in range(20):
		for j in range(20):
			init_tile_at(tiles[i][j], i, j)

	var tile = t_tile_script.new()
	set_tile_at(tile, 3, 1)
	#tile.set_color(colour_script.new(1, 1, 1))
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("lmb"):
		if (get_global_mouse_position() - position).length() < 32:
			position = get_global_mouse_position()
	
func update_at(x: int, y: int):
	var empty_neighbours = []
	var full_neighbours = []
	var tile = tiles[x][y]
	for link in tile.links:
		var offset = to_vector(link)
		var other_x = x+offset.x
		var other_y = y+offset.y
		var other = tiles[other_x][other_y]
		if connected(other, link):
			if other.is_painted:
				full_neighbours.append(other.get_paint())
			else:
				empty_neighbours.append(Vector2i(other_x, other_y))
	if full_neighbours.lenght() > 0:
		var colour = mix(full_neighbours)
		tile.set_color(colour)
		for neighbour in empty_neighbours:
			fill_pipes(neighbour, colour)

func fill_pipes(coords: Vector2i, colour: Colour):
	var x = coords.x
	var y = coords.y
	var tile = tiles[x][y]
	tile.set_color(colour)
	for link in tile.links:
		var offset = to_vector(link)
		fill_pipes(tiles[x+offset.x][y+offset.y], colour)
