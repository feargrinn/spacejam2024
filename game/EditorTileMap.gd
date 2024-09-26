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
	if held_tile:
		var tile_pos = get_coordinates()
		if $background.get_cell_tile_data(tile_pos):
			$"tile".set_cell(tile_pos, 0, held_tile[0], held_tile[1])
			
func to_json(name):
	var converted = {}
	converted["name"] = name
	var size = $background.get_used_rect().size
	converted["height"] = size.y
	converted["width"] = size.x
	converted["inputs"] = {}
	converted["outputs"] = {}
	converted["tiles"] = {}
	return converted
