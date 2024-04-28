extends Tile

class_name NoTile

func _init(_texture: Texture2D):
	z_index = -1
	opaque_texture = _texture

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
