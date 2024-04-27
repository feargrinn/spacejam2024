extends Tile

class_name TTile


# Called when the node enters the scene tree for the first time.
func _ready():
	links.append(Direction.LEFT)
	links.append(Direction.DOWN)
	links.append(Direction.RIGHT)
	
	opaque_texture = preload("res://images/tile_24x24_T_opaque.png")
	transparent_texture = preload("res://images/tile_24x24_T.png")
	
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
