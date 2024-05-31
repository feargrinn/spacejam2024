extends Tile

class_name AntiTile

func _init():
	super._init()
	links.append(Direction.UP)
	links.append(Direction.DOWN)
	pipe_size = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	opaque_texture = preload("res://images/tile_24x24_anti_opaque.png")
	transparent_texture = preload("res://images/tile_24x24_anti.png")
	
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
