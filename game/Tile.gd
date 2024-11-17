extends Area2D

class_name Tile

var paint_script = preload("res://Paint.gd")

var is_replaceable: bool

var tile_position: Vector2i
var tile_type: TileType.Type
var tile_rotation: int
var colour_id: int

static var tile_layer
static var colour_layer
static var hover_layer

enum Direction {
	UP,
	RIGHT,
	DOWN,
	LEFT
}

static func right(direction: int):
	match direction:
		Direction.UP:
			return Direction.RIGHT
		Direction.RIGHT:
			return Direction.DOWN
		Direction.DOWN:
			return Direction.LEFT
		Direction.LEFT:
			return Direction.UP

static func opposite(direction: int) -> int:
	return right(right(direction))

static func to_vector(direction: int):
	match direction:
		Direction.UP:
			return Vector2i(0, -1)
		Direction.RIGHT:
			return Vector2i(1, 0)
		Direction.DOWN:
			return Vector2i(0, 1)
		Direction.LEFT:
			return Vector2i(-1, 0)

var links: Array[int] = []
var is_painted: bool
var color: Colour
var pipe_size: float

func _init(a_tile_position, a_tile_type, a_tile_rotation, a_is_replaceable = false):
	tile_position = a_tile_position
	tile_type = a_tile_type
	tile_rotation = a_tile_rotation

	is_painted = false
	pipe_size = 1.
	is_replaceable = a_is_replaceable

# Called when the node enters the scene tree for the first time.
func _ready():
	print("added ", TileType.Type.find_key(tile_type), " at ", tile_position)
	var shape = CollisionShape2D.new()
	shape.shape = RectangleShape2D.new()
	shape.shape.size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE)
	shape.debug_color = Color.RED
	add_child(shape)
	position = tile_layer.map_to_local(tile_position)
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _rotate_right():
	var new_links: Array[int] = []
	for link in links:
		new_links.append(right(link))
	links = new_links
	var total_alternatives = Globals.TILE_SET.get_child(0).get_alternative_tile_count(TileType.coordinates(tile_type))
	tile_rotation = (tile_rotation + 1) % total_alternatives

func player_rotates_right():
	_rotate_right()
	get_node("/root/Game/TileTurning").play()

func player_rotates_left():
	for i in range(3): _rotate_right()
	get_node("/root/Game/TileTurning").play()

func set_color(new_color: Colour):
	colour_id = Colour.create_coloured_tile(tile_type, tile_rotation, new_color)
	colour_layer.set_cell(tile_position, 0, TileType.coordinates(tile_type), colour_id)

func get_paint() -> Paint:
	return paint_script.new(color, pipe_size)

func _on_mouse_entered():
	#start playing tile music
	hover_layer.set_cell(tile_position, 0, TileType.coordinates(TileType.Type.ERASER))

func _on_mouse_exited():
	#stop playing tile music
	hover_layer.erase_cell(tile_position)

# Check if the other tile is connected to this one, assuming this one has a connection in that direction.
static func connected(other: Tile, direction: int):
	return other.links.any(func(link): return link == opposite(direction))
