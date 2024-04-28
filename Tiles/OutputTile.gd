extends Tile

class_name OutputTile

var is_output_filled: bool

var target_color: Colour

var coordinates: Vector2

func _init(color: Colour):
	self.color = color
	target_color = color
	is_output_filled = false

func set_color(new_color: Colour):
	super.set_color(new_color)
	texture = preload("res://images/tile_24x24_output_transparent.png")
	is_output_filled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	links.append(Direction.UP)
	transparent_texture = preload("res://images/tile_24x24_output_partially_transparent.png")
	super.set_color(color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
