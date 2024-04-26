extends Tile

class_name OutputTile

# Called when the node enters the scene tree for the first time.
func _ready():
	links.append(Direction.UP)

	texture = preload("res://images/tile_24x24_output_partially_transparent.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
