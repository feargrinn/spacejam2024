extends Tile

class_name CrossTile 

# Called when the node enters the scene tree for the first time.
func _ready():
	links.append(Direction.UP)
	links.append(Direction.RIGHT)
	links.append(Direction.DOWN)
	links.append(Direction.LEFT)
	
	opaque_texture = preload("res://images/tile_24x24_cross_opaque.png")
	transparent_texture = preload("res://images/tile_24x24_cross.png")
	
	super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
