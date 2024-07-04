extends VBoxContainer

class_name LevelPicker

var levels: Array[Level]
var level_buttons: Array[LevelButton]
var level_columns: Array[HBoxContainer]

func _init(levels: Array[Level], level_loading_function):
	set_v_size_flags(SIZE_EXPAND)
	self.levels = levels
	for level in range(len(levels)):
		create_level_button(level+1, level_loading_function)

func create_level_button(level: int, level_loading_function):
	if len(level_buttons) % 5 == 0:
		var new_columns = HBoxContainer.new()
		new_columns.set("size_flags_vertical", 3)
		level_columns.append(new_columns)
		self.add_child(new_columns)
	var level_button = LevelButton.new("%d" % level, level_loading_function.bind(self.levels, level))
	level_button.hide()
	level_buttons.append(level_button)
	var level_container = MarginContainer.new()
	level_container.set("size_flags_horizontal", 3)
	level_container.add_child(level_button)
	level_columns.back().add_child(level_container)

func unlock_level(level: int):
	level_buttons[level-1].show()

func unlock_all():
	for button in level_buttons:
		button.show()

func click_level_button(level: int):
	level_buttons[level-1].pressed.emit()

func max_level():
	return len(levels)
