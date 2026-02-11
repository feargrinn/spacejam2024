@tool
class_name TextMarginButton
extends Button


@export var left_margin := 0: 
	set(value):
		left_margin = value
		_calculate_min_size()
@export var top_margin := 0: 
	set(value):
		top_margin = value
		_calculate_min_size()
@export var right_margin := 0: 
	set(value):
		right_margin = value
		_calculate_min_size()
@export var bottom_margin := 0: 
	set(value):
		bottom_margin = value
		_calculate_min_size()


func _ready() -> void:
	_calculate_min_size()


func _set(property: StringName, value: Variant) -> bool:
	if property == "text":
		text = value
		_calculate_min_size()
		return true
	return false


func _calculate_min_size() -> void:
	var font := get_theme_font("font", "Button")
	var font_size := get_theme_font_size("font_size", "Button")
	var text_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
	custom_minimum_size.x = left_margin + text_size.x + right_margin
	custom_minimum_size.y = top_margin + text_size.y + bottom_margin
