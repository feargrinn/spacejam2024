extends Area2D

var tile_rotation = 0

func _on_input_event(_viewport, event, _shape_idx, tile_coords):
	if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_LEFT:
		$"../../../TileMap".held_tile = TileId.new(tile_coords, tile_rotation)
	if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_RIGHT:
		tile_rotation = tile_rotation + 1
