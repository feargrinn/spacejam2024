extends Node

var current_map
var current_level

var sound_system

@onready var _sprite_winning = $Sprite2DWinning
@onready var _sprite_losing = $Sprite2DLosing
@onready var _animation_winning = $Sprite2DWinning/AnimationPlayerWinning
@onready var _animation_losing = $Sprite2DLosing/AnimationPlayerLosing

var winning_sprites = []
var losing_sprites = []


##Loads sounds
func _ready():
	sound_system = load("res://game/shared/sfx/sounds.tscn").instantiate()
	add_child(sound_system)
	for tile_type in TileType.pipe_types:
		$TilePicker/VBoxContainer.add_child(_create_button(tile_type))


##Goes back to lever picker
func _on_exit_level_pressed():
	get_tree().change_scene_to_file("res://menu/lever_picker/base_custom_picker.tscn")
	queue_free()

## Creates clickable tile buttons
func _create_button(tile_type: TileType.Type):
	var container = PickableTile.new(TileType.coordinates(tile_type), TileType.texture(tile_type))
	return container


func _on_next_level_pressed():
	if false: #custom_levels_visible:
		_on_exit_level_pressed()
	else:
		var lever_picker = load("res://menu/lever_picker/base_custom_picker.tscn").instantiate()
		add_sibling(lever_picker)
		reparent(lever_picker)
		lever_picker.get_child(0).level_picker.unlock_level(current_level + 1)
		lever_picker.get_child(0).level_picker.click_level_button(current_level + 1)

func victory_screen(scale: Vector2, all_outputs: Array[Vector2i]):
	_sprite_winning.scale *= scale
	_sprite_winning.rotation_degrees = 0
	for output in all_outputs:
		var sprite_winning = _sprite_winning.duplicate(8)
		add_child(sprite_winning)
		for n in current_map.tile_layer.get_cell_alternative_tile(output):
			sprite_winning.rotation_degrees += 90
		sprite_winning.position = current_map.tile_layer.map_to_local(output)*scale.x + current_map.position
		sprite_winning.visible = true
		winning_sprites.append(sprite_winning)
	_animation_winning.play("winning")
	for sprite in winning_sprites:
		sprite.get_child(0).play("winning")
	sound_system.play("winning")

func _on_retry_pressed():
	var game = load("res://game/level/game.tscn")
	name = "old_game"
	var level_instance = game.instantiate()
	level_instance.current_level = current_level
	var new_map = LevelTileMap.new(current_map.level_data)
	level_instance.add_child(new_map)
	new_map.owner = level_instance
	level_instance.current_map = new_map
	level_instance.current_map.show()
	get_tree().root.add_child(level_instance, true)
	queue_free()

func loser_screen(scale: Vector2, losing_outputs: Dictionary):
	_sprite_losing.scale *= scale
	_sprite_losing.rotation_degrees = 0
	for output in losing_outputs:
		var sprite_losing = _sprite_losing.duplicate(8)
		add_child(sprite_losing)
		for n in current_map.tile_layer.get_cell_alternative_tile(output):
			sprite_losing.rotation_degrees += 90
		sprite_losing.position = current_map.tile_layer.map_to_local(output)*scale.x + current_map.position
		sprite_losing.visible = true
		losing_sprites.append(sprite_losing)
	_animation_losing.play("losing")
	for sprite in losing_sprites:
		sprite.get_child(0).play("losing")
	sound_system.play("losing")
	
	var loser_scene = load("res://menu/in_game/loser_screen/loser_screen.tscn")
	add_child(loser_scene.instantiate())
	
	var create_color_rect = func(colour):
		var rect = ColorRect.new()
		rect.size_flags_horizontal = Control.SIZE_FILL
		rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
		rect.color = colour.color()
		return rect
	var target_list = $LoserScreen/VBoxContainer/ColorDifference/TargetList
	var gotten_list = $LoserScreen/VBoxContainer/ColorDifference/GottenList
	for output in losing_outputs:
		target_list.add_child(create_color_rect.call(losing_outputs[output]["target"]))
		gotten_list.add_child(create_color_rect.call(losing_outputs[output]["actual"]))



func _on_animation_player_winning_animation_finished(_anim_name):
	_sprite_winning.scale = Vector2(1.0 ,1.0)
	for sprite in winning_sprites:
		sprite.queue_free()
	winning_sprites = []
	if true: #custom_levels_visible or (current_level != level_picker.max_level()):
		var victory_scene = load("res://menu/in_game/victory_screen/victory_screen.tscn")
		add_child(victory_scene.instantiate())
	else:
		var credits = load("res://menu/in_game/end_screen/end_screen.tscn")
		add_child(credits.instantiate())


func _on_animation_player_losing_animation_finished(_anim_name):
	_sprite_losing.visible = false
	_sprite_losing.scale = Vector2(1.0 ,1.0)
	for sprite in losing_sprites:
		sprite.queue_free()
	losing_sprites = []
	$LoserScreen.show()
