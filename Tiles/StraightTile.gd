extends Tile

class_name StraightTile


# Called when the node enters the scene tree for the first time.
func _ready():
	links.append(Vector2i(0, -1))
	links.append(Vector2i(0, 1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass