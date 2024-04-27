extends Tile

class_name OutputTile

var is_output_filled: bool

func _init(color: Colour):
	self.color = color
	is_output_filled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	links.append(Direction.UP)
	set_color(color)

	texture = preload("res://images/tile_24x24_output_partially_transparent.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
