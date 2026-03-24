class_name TileInteractor
extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var shape = CollisionShape2D.new()
	shape.shape = RectangleShape2D.new()
	shape.shape.size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE)
	shape.debug_color = Color.RED
	add_child(shape)
