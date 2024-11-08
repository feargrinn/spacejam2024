extends Tile

class_name TTile

func _init():
	super._init()
	tile_type = TileType.coordinates(TileType.Type.T)
	links.append(Direction.LEFT)
	links.append(Direction.DOWN)
	links.append(Direction.RIGHT)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	super._ready()
