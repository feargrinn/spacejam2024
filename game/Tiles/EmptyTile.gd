extends Tile

class_name EmptyTile

func _init():
	super._init()
	is_replaceable = true

# Called when the node enters the scene tree for the first time.
func _ready():
	opaque_texture = preload("res://images/tile_24x24_empty.png")
	transparent_texture = preload("res://images/tile_24x24_empty.png")
	
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
