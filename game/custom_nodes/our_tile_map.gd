@tool
@abstract
class_name OurTileMap
extends Node2D

@export var background_layer: BackgroundLayer
@export var colour_layer: ColourLayer
@export var tile_layer: TileLayer
@export var hover_layer: HoverLayer

var level_data: Level

var held_pipe: Pipe = null
var colour_updater: ColourUpdater


func _ready() -> void:
	if owner != self:
		reset()


func _process(_delta: float):
	if held_pipe:
		if Input.is_action_just_released("RMB"):
			Sounds.play("turning")
			held_pipe.rotate()
		
		if Input.is_action_just_pressed("LMB"):
			_place_held_pipe()


func _place_held_pipe() -> void:
	var mouse_position := get_local_mouse_position()
	var mouse_coords := background_layer.local_to_map(mouse_position)
	
	if !background_layer.is_background(mouse_coords):
		reset_held_pipe()
		return
	
	tile_layer.place_pipe(mouse_coords, held_pipe)
	colour_updater.register_pipe(held_pipe)
	reset_held_pipe()


func _clear_map() -> void:
	for child: Node in [background_layer, colour_layer, tile_layer, hover_layer]:
		if child:
			remove_child(child)
			child.queue_free()
	colour_updater = null


func _set_up_layers() -> void:
	background_layer = BackgroundLayer.new()
	colour_layer = ColourLayer.new()
	tile_layer = TileLayer.new()
	hover_layer = HoverLayer.new()
	
	for layer: TileMapLayer in [background_layer, colour_layer, tile_layer, hover_layer]:
		layer.tile_set = Globals.TILE_SET
		add_child(layer, true)
		if Engine.is_editor_hint():
			layer.owner = EditorInterface.get_edited_scene_root()


func get_coordinates() -> Vector2i:
	return background_layer.local_to_map(get_local_mouse_position())


func set_level(level: Level) -> void:
	level_data = level
	if is_node_ready():
		draw_level()
	else:
		ready.connect(draw_level)


func set_held_pipe(pipe: Pipe) -> void:
	held_pipe = pipe
	hover_layer.set_held_pipe(pipe)


func reset_held_pipe() -> void:
	held_pipe = null
	hover_layer.reset_held_pipe()


func place_input(input: PreInput):
	var pipe := Pipe.from_predata(input)
	tile_layer.place_pipe(Vector2i(input.x, input.y), pipe)
	pipe.colour = input.colour
	colour_updater.register_pipe(pipe)
	colour_layer.set_tile_colour(pipe)
	hover_layer.set_interactor(Vector2i(input.x, input.y))


func place_output(output: PreOutput):
	var pipe := Pipe.from_predata(output)
	tile_layer.place_pipe(Vector2i(output.x, output.y), pipe)
	pipe.target_colour = output.colour
	colour_updater.register_pipe(pipe)
	colour_layer.set_target_colour(pipe)
	hover_layer.set_interactor(Vector2i(output.x, output.y))


func place_tile(pretile: PreTile):
	var pipe := Pipe.from_predata(pretile)
	tile_layer.place_pipe(Vector2i(pretile.x, pretile.y), pipe)
	colour_updater.register_pipe(pipe)
	hover_layer.set_interactor(Vector2i(pretile.x, pretile.y))


func reset() -> void:
	_clear_map()
	_set_up_layers()
	colour_updater = ColourUpdater.new()
	colour_updater.pipe_colour_set.connect(colour_layer.set_tile_colour)


func draw_level():
	reset()
	if !level_data:
		return
	background_layer.set_background(level_data.background)
	for input in level_data.inputs:
		place_input(input)
	for output in level_data.outputs:
		place_output(output)
	for other_tile in level_data.tiles:
		place_tile(other_tile)
