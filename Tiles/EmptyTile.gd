extends Tile

class_name EmptyTile


# Called when the node enters the scene tree for the first time.
func _ready():
	opaque_texture = preload("res://images/tile_24x24_empty.png")
	transparent_texture = preload("res://images/tile_24x24_empty.png")
	
	super._ready()
	is_replaceable = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
