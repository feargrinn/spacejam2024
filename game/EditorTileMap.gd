extends MarginContainer

var held_tile = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_coordinates():
	var mouse_pos_global = get_viewport().get_mouse_position()
	var mouse_pos_local = $background.to_local(mouse_pos_global)
	return $background.local_to_map(mouse_pos_local)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var tile_pos = get_coordinates()
	$"tile_hover".clear()
	if $"background".get_cell_tile_data(tile_pos): #checking if on background
		if held_tile:
			$"tile_hover".set_cell(tile_pos, 0, held_tile[0], held_tile[1])
		else:
			$"tile_hover".set_cell(tile_pos, 0, Vector2i(2,4))
			
func place():
	var in_range = func(vec):
		var rect_position = Vector2i(-7,-5)
		var rect_size = Vector2i(14,10)
		var rect = Rect2i(rect_position, rect_size)
		return rect.has_point(vec)
	if held_tile:
		var tile_pos = get_coordinates()
		var eraser = Vector2i(1,3)
		if in_range.call(tile_pos) and held_tile[0] == Vector2i(0,0):
			$"background".set_cell(tile_pos, 0, held_tile[0], held_tile[1])
		elif held_tile[0] == eraser:
			if $tile.get_cell_tile_data(tile_pos):
				$tile.erase_cell(tile_pos)
			elif $background.get_cell_tile_data(tile_pos):
				$background.erase_cell(tile_pos)
		elif in_range.call(tile_pos) and $background.get_cell_tile_data(tile_pos):
			$"tile".set_cell(tile_pos, 0, held_tile[0], held_tile[1])
			
func to_json(level_name):
	var converted = {}
	converted["name"] = level_name
	var board_size = $background.get_used_rect().size
	converted["height"] = board_size.y
	converted["width"] = board_size.x
	converted["inputs"] = {}
	converted["outputs"] = {}
	converted["tiles"] = {}
	return converted
