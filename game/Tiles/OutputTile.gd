extends Tile

class_name OutputTile

var is_output_filled: bool

var target_color: Colour

var coordinates: Vector2

func _init(color: Colour):
	super._init()
	tile_type = TileType.OUTPUT()
	links.append(Direction.UP)
	target_color = color
	is_output_filled = false

func set_color(new_color: Colour):
	super.set_color(new_color)
	is_output_filled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	super.set_color(target_color)
