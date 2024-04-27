extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_mouse_entered_tile(extra_arg_0):
	get_parent().get_child(2).current_tile = extra_arg_0


func _on_i_mouse_exited():
	get_parent().get_child(2).current_tile = null


