class_name LevelPicker
extends GridContainer

signal level_picked(levels: Array[Level], level_id: int)

var levels: Array[Level]: set = _set_levels
var level_buttons: Array[LevelButton]


func _set_levels(value: Array[Level]) -> void:
	levels = value
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	for level_id in levels.size():
		create_level_button(level_id)


func create_level_button(level: int):
	var level_button = LevelButton.new("%d" % (level + 1))
	level_button.hide()
	level_buttons.append(level_button)
	add_child(level_button)
	level_button.pressed.connect(level_picked.emit.bind(levels, level))


func unlock_level(level: int):
	level_buttons[level-1].show()


func unlock_all():
	for button in level_buttons:
		button.show()


func max_level():
	return len(levels)
