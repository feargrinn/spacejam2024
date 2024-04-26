extends Sprite2D

const empty_tile_script = preload("res://Tiles/EmptyTile.gd")
const t_tile_script = preload("res://Tiles/TTile.gd")
const straight_tile_script = preload("res://Tiles/StraightTile.gd")
const bend_tile_script = preload("res://Tiles/LTile.gd")

const TILE_SIZE = 24

var tiles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(18):
		var tilesRow = []
		for j in range(18):
			tilesRow.append(empty_tile_script.new())

		tiles.append(tilesRow)

	for i in range(18):
		for j in range(18):
			set_tile_at(tiles[i][j], i, j)

	set_tile_at(t_tile_script.new(), 3, 1)
	
func set_tile_at(tile:Tile, ix:int, iy:int, rot: int = 0):
	tiles[ix][iy] = tile
	add_child(tile)
	tile.position = position + Vector2((ix + 0.5) * TILE_SIZE, (iy + 0.5) * TILE_SIZE)
	for i in range(rot):
		tile.rotate_right()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("lmb"):
		if (get_global_mouse_position() - position).length() < 32:
			position = get_global_mouse_position()
	
	
