@tool
class_name CreatorTileMap
extends OurTileMap

var held_tool


func _ready() -> void:
	reset()
	background_layer.set_background({
		Vector2i(1,1): true,
		Vector2i(1,2): true,
		Vector2i(1,3): true,
		Vector2i(1,4): true,
		Vector2i(2,1): true,
		Vector2i(2,2): true,
		Vector2i(2,3): true,
		Vector2i(2,4): true,
	})
	position = Globals.WINDOW_SIZE / 2
