extends Tile

class_name StraightTile

func _init():
	super._init()
	tile_type = TileType.STRAIGHT()
	links.append(Direction.UP)
	links.append(Direction.DOWN)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	super._ready()
