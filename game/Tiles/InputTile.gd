extends Tile

class_name InputTile

func _init(a_color: Colour):
	super._init()
	tile_type = TileType.coordinates(TileType.Type.INPUT)
	links.append(Direction.DOWN)
	set_color(a_color)

func _ready():
	super._ready()
