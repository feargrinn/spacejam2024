extends Node

var current_map

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_exit_level_pressed():
	current_map.current_tile = null
	remove_child(current_map)
	current_map.hide()
	$ExitLevel.hide()
	$LeverPicker.show()
	$TilePicker.hide()


func _on_level_pressed(level: int):
	var new_map = Sprite2D.new()
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
	add_child(new_map)
	current_map = new_map
	$LeverPicker.hide()
	$TilePicker.show()
	$ExitLevel.show()
	current_map.show()
