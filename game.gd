extends Node

var current_map
var current_level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func unload_level():
	current_map.current_tile = null
	remove_child(current_map)
	current_map.hide()
	$ExitLevel.hide()
	$TilePicker.hide()

func _on_exit_level_pressed():
	unload_level()
	$LeverPicker.show()

func _on_level_pressed(level: int):
	current_level = level
	var new_map = Sprite2D.new()
	new_map.name = "map"
	if level == 1:
		new_map.set_script(preload("res://Levels/LevelOne.gd"))
	elif level == 2:
		new_map.set_script(preload("res://Levels/LevelTwo.gd"))
	elif level == 3:
		new_map.set_script(preload("res://Levels/LevelThree.gd"))
	elif level == 4:
		new_map.set_script(preload("res://Levels/LevelFour.gd"))
	elif level == 5:
		new_map.set_script(preload("res://Levels/LevelFive.gd"))
	elif level == 6:
		new_map.set_script(preload("res://Levels/LevelSix.gd"))
	add_child(new_map)
	current_map = new_map
	$LeverPicker.hide()
	$TilePicker.show()
	$ExitLevel.show()
	current_map.show()

func _on_next_level_pressed():
	$VictoryScreen.hide()
	match current_level:
		1:
			$LeverPicker/Rows/Columns/MarginContainer2/Level.show()
		2:
			$LeverPicker/Rows/Columns/MarginContainer3/Level.show()
		3:
			$LeverPicker/Rows/Columns/MarginContainer4/Level.show()
		4:
			$LeverPicker/Rows/Columns/MarginContainer5/Level.show()
	_on_level_pressed(current_level + 1)

func victory_screen():
	unload_level()
	$VictoryScreen.show()

func _on_retry_pressed():
	$LoserScreen.hide()
	_on_level_pressed(current_level)

func loser_screen():
	unload_level()
	$LoserScreen.show()
