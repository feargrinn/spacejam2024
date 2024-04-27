extends MarginContainer

var current_tile = null;
var left_mouse_was_pressed = false;
var right_mouse_was_pressed = false;
var tile = null;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _mouse_position_to_coordinates():
	#tile.position = position + Vector2(
	#	(ix + 0.5) * Globals.TILE_SIZE,
	#	(iy + 0.5) * Globals.TILE_SIZE
	#)
	var vec = get_global_mouse_position() - $"../Map".position
	var x = vec[0]/Globals.TILE_SIZE;
	var y = vec[1]/Globals.TILE_SIZE;
	return [x,y]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and left_mouse_was_pressed and tile != null:
		tile.position = get_global_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and right_mouse_was_pressed == false and tile != null:
		right_mouse_was_pressed = true;
		tile.rotate_right()
	if Input.is_action_just_released("RMB"):
		right_mouse_was_pressed = false
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and left_mouse_was_pressed == false:
		left_mouse_was_pressed = true
		print(current_tile)
		match current_tile:
			null:
				pass
			1:
				tile = TTile.new()
				tile.position = get_global_mouse_position()
				$"../Map".add_child(tile)
			2:
				tile = TTile.new()
				tile.position = get_global_mouse_position()
				$"../Map".add_child(tile)
			3:
				tile = BendTile.new()
				tile.position = get_global_mouse_position()
				$"../Map".add_child(tile)
	
	if Input.is_action_just_released("LMB") and tile != null:
		left_mouse_was_pressed = false
		var position = _mouse_position_to_coordinates()
		$"../Map".remove_child(tile)
		if position[0] >= 0 and position[0] < 20 and position[1] >= 0 and position[1] < 20:
			$"../Map".set_tile_at(tile, position[0], position[1], 0);
		tile = null;


func _on_mouse_entered_tile(extra_arg_0):
	current_tile = extra_arg_0


func _on_i_mouse_exited():
	current_tile = null
