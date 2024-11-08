extends Tile

class_name AntiTile

func _init():
	super._init()
	tile_type = TileType.coordinates(TileType.Type.ANTI)
	links.append(Direction.UP)
	links.append(Direction.DOWN)
	pipe_size = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	
	super._ready()
