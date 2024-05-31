extends Tile

class_name TTile

func _init():
	super._init()
	links.append(Direction.LEFT)
	links.append(Direction.DOWN)
	links.append(Direction.RIGHT)

# Called when the node enters the scene tree for the first time.
func _ready():
	opaque_texture = preload("res://images/tile_24x24_T_opaque.png")
	transparent_texture = preload("res://images/tile_24x24_T.png")
	
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
