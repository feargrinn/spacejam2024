extends Node

var current_map
var current_level
var save_data: PlayerData
var level_picker: LevelPicker
var custom_level_picker: LevelPicker
var custom_levels_visible: bool

var winning_sound
var losing_sound

@onready var _sprite_winning = $Sprite2DWinning
@onready var _sprite_losing = $Sprite2DLosing
@onready var _animation_winning = $Sprite2DWinning/AnimationPlayerWinning
@onready var _animation_losing = $Sprite2DLosing/AnimationPlayerLosing

var winning_sprites = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var loaded_levels = Level.load_default()
	if loaded_levels is Error:
		print("Failed to load levels: ", loaded_levels.as_string(), ".")
	print("Loaded ", loaded_levels.size(), " levels.")
	level_picker = LevelPicker.new(loaded_levels, self._on_level_pressed)
	$LeverPicker/VBoxContainer.add_child(level_picker)
	level_picker.show()
	$LeverPicker/VBoxContainer/HBoxContainer/Base.set_disabled(true)
	var loaded_data = PlayerData.load_default()
	if loaded_data is Error:
		print("Failed to load game state: ", loaded_data.as_string(), ".")
		save_data = PlayerData.new()
	else:
		save_data = loaded_data
	for level in range(save_data.get_reached_level()):
		level_picker.unlock_level(level+1)
	var loaded_user_levels = Level.load_user()
	if loaded_user_levels is Error:
		print("Failed to load user levels: ", loaded_user_levels.as_string(), ".")
	else:
		print("Loaded ", loaded_user_levels.size(), " custom levels.")
		if len(loaded_user_levels) > 0:
			custom_level_picker = LevelPicker.new(loaded_user_levels, self._on_level_pressed)
			custom_level_picker.unlock_all()
			custom_level_picker.hide()
			custom_levels_visible = false
			$LeverPicker/VBoxContainer.add_child(custom_level_picker)
			$LeverPicker/VBoxContainer/HBoxContainer/Custom.set_disabled(false)
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
	remove_child(current_map)
	current_map.hide()
	$ExitLevel.hide()
	$TilePicker.hide()

func _on_exit_level_pressed():
	_sprite_winning.scale = Vector2(1.0 ,1.0)
	for sprite in winning_sprites:
		sprite.visible = false;
		sprite.get_child(0).stop()
		
	_sprite_losing.visible = false
	_sprite_losing.scale = Vector2(1.0 ,1.0)
	_animation_winning.stop()
	_animation_losing.stop()
	winning_sound.stop()
	losing_sound.stop()
	unload_level()
	$LeverPicker.show()

func _on_level_pressed(levels: Array[Level], level: int):
	current_level = level
	var new_map = Map.new(levels[level-1])
	
	add_child(new_map)
	current_map = new_map
	$LeverPicker.hide()
	$TilePicker.show()
	$ExitLevel.show()
	current_map.show()

func unlock_level(level: int):
	level_picker.unlock_level(level)
	save_data.unlock_level(level)

func _on_next_level_pressed():
	$VictoryScreen.hide()
	if custom_levels_visible:
		_on_exit_level_pressed()
	else:
		unlock_level(current_level + 1)
		level_picker.click_level_button(current_level + 1)

func victory_screen(scale: Vector2, all_outputs: Array[OutputTile]):
	_sprite_winning.scale *= scale
	_sprite_winning.rotation_degrees = 0
	for output in all_outputs:
		var sprite_winning = _sprite_winning.duplicate(8)
		add_child(sprite_winning)
		for n in output.links[0]:
			sprite_winning.rotation_degrees += 90
		sprite_winning.position = output.global_position
		sprite_winning.visible = true
		winning_sprites.append(sprite_winning)
	_animation_winning.play("winning")
	for sprite in winning_sprites:
		sprite.get_child(0).play("winning")
	winning_sound.play()

func _on_retry_pressed():
	$LoserScreen.hide()
	level_picker.click_level_button(current_level)

func loser_screen(scale: Vector2, losing_output: OutputTile):
	_sprite_losing.scale *= scale
	_sprite_losing.rotation_degrees = 0
	for n in losing_output.links[0]:
		_sprite_losing.rotation_degrees += 90
	_sprite_losing.position = losing_output.global_position
	_sprite_losing.visible = true
	_animation_losing.play("losing")
	losing_sound.play()
	$LoserScreen/VBoxContainer/ColorDifference/ColorDifference/Target.color = losing_output.target_color.color()
	$LoserScreen/VBoxContainer/ColorDifference/ColorDifference2/Gotten.color = losing_output.color.color()

func _on_exit_level_picker_pressed():
	$LeverPicker.hide()
	get_tree().change_scene_to_file("res://node_2d.tscn")

func _on_custom_pressed():
	$LeverPicker/VBoxContainer/HBoxContainer/Custom.set_disabled(true)
	$LeverPicker/VBoxContainer/HBoxContainer/Base.set_disabled(false)
	level_picker.hide()
	custom_level_picker.show()
	custom_levels_visible = true

func _on_base_pressed():
	$LeverPicker/VBoxContainer/HBoxContainer/Base.set_disabled(true)
	$LeverPicker/VBoxContainer/HBoxContainer/Custom.set_disabled(false)
	custom_level_picker.hide()
	level_picker.show()
	custom_levels_visible = false

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
	pass

func _on_animation_player_winning_animation_finished(anim_name):
	_sprite_winning.scale = Vector2(1.0 ,1.0)
	for sprite in winning_sprites:
		sprite.queue_free()
	winning_sprites = []
	if custom_levels_visible or (current_level != level_picker.max_level()):
		unload_level()
		$VictoryScreen.show()
	else:
		play_credits();


func _on_animation_player_losing_animation_finished(anim_name):
	_sprite_losing.visible = false
	_sprite_losing.scale = Vector2(1.0 ,1.0)
	unload_level()
	$LoserScreen.show()
