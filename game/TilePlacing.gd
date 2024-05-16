extends MarginContainer

var map;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_mouse_entered_tile(extra_arg_0):
	var parent = get_parent();
	var children = parent.get_children()
	for child in children:
		if child.name == "map":
			map = child
	map.current_tile = extra_arg_0
	
	
func _on_mouse_exited_tile():
	var parent = get_parent();
	var children = parent.get_children()
	for child in children:
		if child.name == "map":
			map = child
	map.current_tile = null


