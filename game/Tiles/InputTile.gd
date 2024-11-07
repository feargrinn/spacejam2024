extends Tile

class_name InputTile

func _init(color: Colour):
	super._init()
	tile_type = TileType.INPUT()
	links.append(Direction.DOWN)
	set_color(color)

func _ready():
	super._ready()
