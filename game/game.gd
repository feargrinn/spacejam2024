extends Node

var current_map
var current_level

var winning_sound
var losing_sound

@onready var _sprite_winning = $Sprite2DWinning
@onready var _sprite_losing = $Sprite2DLosing
@onready var _animation_winning = $Sprite2DWinning/AnimationPlayerWinning
@onready var _animation_losing = $Sprite2DLosing/AnimationPlayerLosing

# Called when the node enters the scene tree for the first time.
func _ready():
	winning_sound = AudioStreamPlayer.new()
	winning_sound.stream = preload("res://sfx/sfx_winning_animation.wav")
	add_child(winning_sound)
	losing_sound = AudioStreamPlayer.new()
	losing_sound.stream = preload("res://sfx/sfx_losing_animation.wav")
	add_child(losing_sound)

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
	_sprite_winning.visible = false
	_sprite_winning.scale = Vector2(1.0 ,1.0)
	_sprite_losing.visible = false
	_sprite_losing.scale = Vector2(1.0 ,1.0)
	_animation_winning.stop()
	_animation_losing.stop()
	winning_sound.stop()
	losing_sound.stop()
	unload_level()
	$LeverPicker.show()

func _on_level_pressed(level: int):
	current_level = level
	var new_map = Sprite2D.new()
	new_map.name = "map"
	
	const FILE_BEGIN = "res://Levels/Level_"
	var level_path
	if level < 10:
		level_path = FILE_BEGIN + "0" + str(level) + ".gd"
	else:
		level_path = FILE_BEGIN + str(level) + ".gd"
	new_map.set_script(load(level_path))
	
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
	var output = all_outputs[RandomNumberGenerator.new().randi_range(0, all_outputs.size()-1)]
	for n in output.links[0]:
		_sprite_winning.rotation_degrees += 90
	_sprite_winning.position = output.global_position
	_sprite_winning.visible = true
	_animation_winning.play("winning")
	winning_sound.play()

func _on_retry_pressed():
	$LoserScreen.hide()
	_on_level_pressed(current_level)

func loser_screen(scale: Vector2, losing_output: OutputTile):
	_sprite_losing.scale *= scale
	_sprite_losing.rotation_degrees = 0
	for n in losing_output.links[0]:
		_sprite_losing.rotation_degrees += 90
	_sprite_losing.position = losing_output.global_position
	_sprite_losing.visible = true
	_animation_losing.play("losing")
	losing_sound.play()


func _on_exit_level_picker_pressed():
	$LeverPicker.hide()
	get_tree().change_scene_to_file("res://node_2d.tscn")

func play_credits():
	var delay = 500.
	$Credits.show()
	$RichTextLabel.show()
	$Credits.set_color("84A98C33")
	await get_tree().create_timer(delay/1000).timeout
	$Credits.set_color("84A98C66")
	await get_tree().create_timer(delay/1000).timeout
	$Credits.set_color("52796F99")
	await get_tree().create_timer(delay/1000).timeout
	$Credits.set_color("354F52CC")
	await get_tree().create_timer(delay/1000).timeout
	$Credits.set_color("2F3E46FF")
	await get_tree().create_timer(delay/1000).timeout
	while $RichTextLabel.position.y>-300:
		$RichTextLabel.position.y -= 10
		await get_tree().create_timer(delay/5000).timeout
		OS.delay_msec(delay/5);
		print($RichTextLabel.position.y )
	pass

func _on_animation_player_winning_animation_finished(anim_name):
	_sprite_winning.visible = false
	_sprite_winning.scale = Vector2(1.0 ,1.0)
	if current_level != 10:
		unload_level()
		$VictoryScreen.show()
	else:
		play_credits();


func _on_animation_player_losing_animation_finished(anim_name):
	_sprite_losing.visible = false
	_sprite_losing.scale = Vector2(1.0 ,1.0)
	unload_level()
	$LoserScreen.show()