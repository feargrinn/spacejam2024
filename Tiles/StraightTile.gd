extends Tile

class_name StraightTile


# Called when the node enters the scene tree for the first time.
func _ready():
	links.append(Direction.UP)
	links.append(Direction.DOWN)
	
	opaque_texture = preload("res://images/tile_24x24_I_opaque.png")
	transparent_texture = preload("res://images/tile_24x24_I.png")
	
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
