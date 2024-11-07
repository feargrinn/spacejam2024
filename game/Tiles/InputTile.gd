extends Tile

class_name InputTile

func _init(color: Colour):
	super._init()
	tiletype = TileType.INPUT()
	links.append(Direction.DOWN)
	set_color(color)

func _ready():
	transparent_texture = preload("res://images/tile_24x24_input_transparent.png")
	super._ready()
	texture = transparent_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
