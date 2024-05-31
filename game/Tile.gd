extends Sprite2D

class_name Tile

var paint_script = preload("res://Paint.gd")
var colour_script = preload("res://Colour.gd")
var transparent_texture: Texture2D
var opaque_texture: Texture2D
var is_replaceable: bool

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

func _init():
	is_painted = false
	pipe_size = 1.
	is_replaceable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if is_painted:
		texture = transparent_texture
	else:
		texture = opaque_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func rotate_right():
	var new_links: Array[int] = []
	for link in links:
		new_links.append(right(link))
	links = new_links
	rotate(PI / 2)
	
func set_color(new_color: Colour):
	if is_painted:
		remove_child(color)
	else:
		is_painted = true
		texture = transparent_texture

	color = colour_script.new(new_color.r, new_color.y, new_color.b)
	add_child(color)

func get_paint() -> Paint:
	return paint_script.new(color, pipe_size)

# Check if the other tile is connected to this one, assuming this one has a connection in that direction.
static func connected(other: Tile, direction: int):
	return other.links.any(func(link): return link == opposite(direction))
