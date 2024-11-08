extends Tile

class_name LTile

func _init():
	super._init()
	tile_type = TileType.coordinates(TileType.Type.L)
	links.append(Direction.UP)
	links.append(Direction.RIGHT)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	super._ready()
	
