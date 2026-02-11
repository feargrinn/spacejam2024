class_name LevelButton
extends Button


func _init(level_name: String):
	set_text(level_name)
	icon = load("res://menu/shared/graphics/buttons/menu_button_lvl_empty.png")
	set_icon_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	set_vertical_icon_alignment(VERTICAL_ALIGNMENT_CENTER)
	set_flat(true)
