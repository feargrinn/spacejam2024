extends Sprite2D

class_name Tile

const TileRotation = {
	UP = 0,
	RIGHT = 1,
	DOWN = 2,
	LEFT = 3
}

var links: Array[Vector2i] = []
var rot:int
var texture_to_set : Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	rot = TileRotation.UP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
