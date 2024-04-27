extends Node

var current_map
var current_level

@onready var _sprite_winning = $Sprite2DWinning
@onready var _sprite_losing = $Sprite2DLosing
@onready var _animation_winning = $Sprite2DWinning/AnimationPlayerWinning
@onready var _animation_losing = $Sprite2DLosing/AnimationPlayerLosing

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
	match level:
		1:
			new_map.set_script(preload("res://Levels/LevelOne.gd"))
		2:
			new_map.set_script(preload("res://Levels/LevelTwo.gd"))
		3:
			new_map.set_script(preload("res://Levels/LevelThree.gd"))
		4:
			new_map.set_script(preload("res://Levels/LevelFour.gd"))
		5:
			new_map.set_script(preload("res://Levels/LevelFive.gd"))
		6:
			new_map.set_script(preload("res://Levels/LevelSix.gd"))
		7:
			new_map.set_script(preload("res://Levels/LevelSeven.gd"))
		8:
			new_map.set_script(preload("res://Levels/LevelEight.gd"))
		9:
			new_map.set_script(preload("res://Levels/LevelNine.gd"))
		10:
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

func victory_screen(scale: Vector2, all_outputs: Array[OutputTile]):
	_sprite_winning.scale *= scale
	_sprite_winning.rotation_degrees = 0
	for i in all_outputs.size():
		for n in all_outputs[i].links[0]:
			_sprite_winning.rotation_degrees += 90
		_sprite_winning.position = all_outputs[i].global_position
		_sprite_winning.visible = true
		_animation_winning.play("winning")

func _on_retry_pressed():
	$LoserScreen.hide()
	_on_level_pressed(current_level)

func loser_screen(scale: Vector2, all_outputs: Array[OutputTile]):
	_sprite_losing.scale *= scale
	_sprite_losing.rotation_degrees = 0
	for i in all_outputs.size():
		for n in all_outputs[i].links[0]:
			_sprite_losing.rotation_degrees += 90
		_sprite_losing.position = all_outputs[i].global_position
		_sprite_losing.visible = true
		_animation_losing.play("losing")


func _on_exit_level_picker_pressed():
	$LeverPicker.hide()
	get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_animation_player_winning_animation_finished(anim_name):
	_sprite_winning.visible = false
	_sprite_winning.scale = Vector2(1.0 ,1.0)
	unload_level()
	$VictoryScreen.show()


func _on_animation_player_losing_animation_finished(anim_name):
	_sprite_losing.visible = false
	_sprite_losing.scale = Vector2(1.0 ,1.0)
	unload_level()
	$LoserScreen.show()
