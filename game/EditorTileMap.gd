extends TileMap

var held_tile = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_coordinates():
	var mouse_pos_global = get_viewport().get_mouse_position()
	var mouse_pos_local = to_local(mouse_pos_global)
	return local_to_map(mouse_pos_local)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var tile_pos = get_coordinates()
	clear_layer(3)
	if get_cell_tile_data(0, tile_pos):
		if held_tile:
			set_cell(3, tile_pos, 0, held_tile[0], held_tile[1])
		else:
			set_cell(3, tile_pos, 0, Vector2i(2,4))
			
func place():
	if held_tile:
		var tile_pos = get_coordinates()
		set_cell(1, tile_pos, 0, held_tile[0], held_tile[1])
