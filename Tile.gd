extends Sprite2D

class_name Tile

var paint_script = preload("res://Paint.gd")

const Direction = {
	UP = 0,
	RIGHT = 1,
	DOWN = 2,
	LEFT = 3
}

func right(direction: int):
	if direction == Direction.UP:
		return Direction.RIGHT
	if direction == Direction.RIGHT:
		return Direction.DOWN
	if direction == Direction.DOWN:
		return Direction.LEFT
	if direction == Direction.LEFT:
		return Direction.UP

var links: Array[int] = []
var texture_to_set : Texture
var is_painted: bool
var color: Colour
var pipe_size: float

# Called when the node enters the scene tree for the first time.
func _ready():
	is_painted = false
	pipe_size = 1.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func rotate_right():
	var new_links = []
	for link in links:
		new_links.append(right(link))
	links = new_links
	
func set_color(_color: Colour):
	is_painted = true
	color = _color

func get_paint() -> Paint:
	return paint_script.new(color, pipe_size)
