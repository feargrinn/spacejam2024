extends Node2D


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
	$LeverPicker.hide()
