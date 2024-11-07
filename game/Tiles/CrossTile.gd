extends Tile

class_name CrossTile 

func _init():
	super._init()
	tile_type = TileType.CROSS()
	links.append(Direction.UP)
	links.append(Direction.RIGHT)
	links.append(Direction.DOWN)
	links.append(Direction.LEFT)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
