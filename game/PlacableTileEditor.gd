extends Area2D

var tile_rotation = 0
var mouse_over = false

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_LEFT:
		$"../../../TileMap".held_tile = [Vector2i(0,0), tile_rotation]
	if event is InputEventMouseButton and event.pressed == false and event.button_index == MOUSE_BUTTON_RIGHT:
		tile_rotation = (tile_rotation + 1) % 4

func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false
