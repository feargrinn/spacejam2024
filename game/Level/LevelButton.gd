extends Button

class_name LevelButton

func _init(level_name: String, loading_function):
	set_text(level_name)
	icon = load("res://menu/graphics/buttons/menu_button_lvl_empty.png")
	set_icon_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	set_vertical_icon_alignment(VERTICAL_ALIGNMENT_CENTER)
	set_flat(true)
	self.pressed.connect(loading_function)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
