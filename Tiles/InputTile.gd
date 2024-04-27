extends Tile

class_name InputTile

func _init(color: Colour):
	self.color = color

func _ready():
	links.append(Direction.DOWN)
	
	transparent_texture = preload("res://images/tile_24x24_input_transparent.png")
	
	super._ready()
	set_color(color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
