extends Tile

class_name InputTile

# Called when the node enters the scene tree for the first time.
func _ready():
	links.append(Direction.DOWN)

	texture = preload("res://images/tile_24x24_input_transparent.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
