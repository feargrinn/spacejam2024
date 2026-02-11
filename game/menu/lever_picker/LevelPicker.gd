class_name LevelPicker
extends GridContainer

var levels: Array[Level]
var level_buttons: Array[LevelButton]


func _init(a_levels: Array[Level], level_loading_function: Callable):
	set_v_size_flags(SIZE_SHRINK_CENTER)
	set_h_size_flags(SIZE_SHRINK_CENTER)
	
	self.levels = a_levels
	columns = 5
	for level in range(len(levels)):
		create_level_button(level+1, level_loading_function)


func create_level_button(level: int, level_loading_function: Callable):
	var level_button = LevelButton.new("%d" % level)
	level_button.hide()
	level_buttons.append(level_button)
	add_child(level_button)
	level_button.pressed.connect(level_loading_function.bind(self.levels, level))


func unlock_level(level: int):
	level_buttons[level-1].show()


func unlock_all():
	for button in level_buttons:
		button.show()


func click_level_button(level: int):
	level_buttons[level-1].pressed.emit()


func max_level():
	return len(levels)
