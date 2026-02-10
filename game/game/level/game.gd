class_name Game
extends Node

var current_map
var current_level


func _ready():
	for tile_type in TileType.pipe_types:
		%TilePicker.add_child(_create_button(tile_type))


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


func victory_screen():
	if true: #custom_levels_visible or (current_level != level_picker.max_level()):
		var victory_scene: VictoryScreen = preload("uid://c5jhprfubvllq").instantiate()
		$Controls.add_child(victory_scene)
		victory_scene.next_level_requested.connect(_on_next_level_pressed)
	else:
		var credits = load("res://menu/in_game/end_screen/end_screen.tscn")
		$Controls.add_child(credits.instantiate())


func _on_retry_pressed():
	var new_map = LevelTileMap.new(current_map.level_data)
	for child in $"2D".get_children():
		# Some places look for node named "map", adding second map before freeing
		# this one makes it "map2", hence name change
		# but the places that look for "map" probably shouldn't do it anyway... #TODO
		child.name += "_old"
		child.queue_free()
	$"2D".add_child(new_map, true)
	current_map = new_map


func loser_screen(losing_outputs: Dictionary):
	var loser_scene := LoserScreen.custom_new(losing_outputs)
	$Controls.add_child(loser_scene)
	loser_scene.retry_requested.connect(_on_retry_pressed)
	loser_scene.retry_requested.connect(loser_scene.queue_free)
