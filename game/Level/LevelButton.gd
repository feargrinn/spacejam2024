extends Button

class_name LevelButton

func _init(level: int, game):
	set_text("%d" % level)
	set("theme_override_fonts/font", load("res://fonts/menu_font.ttf"))
	set("theme_override_font_sizes/font_size", 64)
	var icon = load("res://images/menu_button_lvl_empty.png")
	set_button_icon(icon)
	set_icon_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	set_vertical_icon_alignment(VERTICAL_ALIGNMENT_CENTER)
	set_flat(true)
	self.pressed.connect(game._on_level_pressed.bind(level))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
