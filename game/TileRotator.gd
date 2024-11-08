extends HBoxContainer


func _ready():
	get_child(0).connect("pressed", _on_rotate_left_pressed)
	#get_child(1).get_child(0).connect("input_event", _on_click)
	get_child(2).connect("pressed", _on_rotate_right_pressed)

func _on_rotate_left_pressed():
	get_child(1).get_child(0).get_child(1).rotation -= PI/2
	get_node("/root/Game/TileTurning").play()


func _on_rotate_right_pressed():
	get_child(1).get_child(0).get_child(1).rotation += PI/2
	get_node("/root/Game/TileTurning").play()


func _on_click(_viewport: Node, event: InputEvent, _shape_idx: int, tile_type: Vector2i) -> void:
	if event is InputEventMouseButton and event.is_released() and not event.is_echo() and event.button_index == MOUSE_BUTTON_RIGHT:
		_on_rotate_right_pressed()
	elif event is InputEventMouseButton and event.is_released() and not event.is_echo() and event.button_index == MOUSE_BUTTON_LEFT:
		var max_alternatives = Globals.TILE_SET.get_source(0).get_alternative_tiles_count(tile_type)
		var tile_rotation = int(get_child(1).get_child(0).get_child(1).rotation_degrees/360*4)
		get_node("/root/Game/map").tile["position"] = tile_type
		get_node("/root/Game/map").tile["alternative_id"] = tile_rotation % max_alternatives
