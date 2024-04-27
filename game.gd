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
	elif level == 7:
		new_map.set_script(preload("res://Levels/LevelSeven.gd"))
	elif level == 8:
		new_map.set_script(preload("res://Levels/LevelEight.gd"))
	elif level == 9:
		new_map.set_script(preload("res://Levels/LevelNine.gd"))
	elif level == 10:
		new_map.set_script(preload("res://Levels/LevelTen.gd"))
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
			$LeverPicker/VBoxContainer/Rows/Columns/MarginContainer2/Level.show()
		2:
			$LeverPicker/VBoxContainer/Rows/Columns/MarginContainer3/Level.show()
		3:
			$LeverPicker/VBoxContainer/Rows/Columns/MarginContainer4/Level.show()
		4:
			$LeverPicker/VBoxContainer/Rows/Columns/MarginContainer5/Level.show()
		5:
			$LeverPicker/VBoxContainer/Rows/Columns2/MarginContainer/Level.show()
		6:
			$LeverPicker/VBoxContainer/Rows/Columns2/MarginContainer2/Level.show()
		7:
			$LeverPicker/VBoxContainer/Rows/Columns2/MarginContainer3/Level.show()
		8:
			$LeverPicker/VBoxContainer/Rows/Columns2/MarginContainer4/Level.show()
		9:
			$LeverPicker/VBoxContainer/Rows/Columns2/MarginContainer5/Level.show()
		10:
			$LeverPicker/VBoxContainer/Rows/Columns3/MarginContainer/Level.show()
	_on_level_pressed(current_level + 1)

func victory_screen():
	# winning anim # sprite sheet animation
	unload_level()
	$VictoryScreen.show()

func _on_retry_pressed():
	$LoserScreen.hide()
	_on_level_pressed(current_level)

func loser_screen():
	# losing anim
	unload_level()
	$LoserScreen.show()


func _on_exit_level_picker_pressed():
	$LeverPicker.hide()
	get_tree().change_scene_to_file("res://node_2d.tscn")
