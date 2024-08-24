extends HBoxContainer


func _ready():
	get_child(0).connect("pressed", _on_rotate_left_pressed)
	get_child(2).connect("pressed", _on_rotate_right_pressed)

func _on_rotate_left_pressed():
	get_child(1).get_child(0).get_child(1).player_rotates_left()


func _on_rotate_right_pressed():
	get_child(1).get_child(0).get_child(1).player_rotates_right()
