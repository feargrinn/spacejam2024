extends Tile

class_name NoTile

func _init(_texture: Texture2D):
	super._init()
	z_index = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
