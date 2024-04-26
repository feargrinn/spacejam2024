extends Tile

class_name TTile


# Called when the node enters the scene tree for the first time.
func _ready():
	links.append(Vector2i(0, -1))
	links.append(Vector2i(1, 0))
	links.append(Vector2i(0, 1))
	
	texture = preload("res://images/tile_24x24_T.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
