class_name LevelTileMap
extends Node2D

signal level_won
signal animation_losing_finished(losing_outputs: Dictionary[Vector2i, Dictionary])
signal animation_winning_finished

const LEVEL_TILE_MAP = preload("uid://dys1pp7uead78")

enum Layer{
	BACKGROUND,
	COLOUR,
	TILE,
	HOVER
}

var level_data: Level
var color_translation = {}


var losing_outputs: Dictionary[Vector2i, Dictionary]

var current_tile = null;
var held_pipe: Pipe = null
var is_running: bool
var level_name: String


@onready var layers: Dictionary[Layer, TileMapLayer] = {
	Layer.BACKGROUND : %BackgroundLayer,
	Layer.COLOUR : %ColourLayer,
	Layer.TILE : %TileLayer,
	Layer.HOVER : %TileHoverLayer
}

# The stream player still shouldn't be here I think, but it's better
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	is_running = true
	TileInteractor.hover_layer = layers[Layer.HOVER]


func _set_layer(value: TileMapLayer, index: Layer) -> void:
	if layers[index]:
		var old_layer: TileMapLayer = layers[index]
		layers[index] = null
		remove_child(old_layer)
		old_layer.queue_free()
	layers[index] = value
	layers[index].tile_set = Globals.TILE_SET
	add_child(layers[index], true)
	move_child(layers[index], index)
	return


func set_level(level: Level) -> void:
	level_data = level
	if is_node_ready():
		draw_starting_map()
	else:
		ready.connect(draw_starting_map)


func set_held_tile(pipe: Pipe) -> void:
	held_pipe = pipe


func scale_from_dimensions(dimensions: Vector2i) -> Vector2:
	if max(dimensions.x, dimensions.y) <= 10:
		return Vector2(2, 2)
	else:
		return Vector2(1, 1)


func place_input(input: PreInput):
	var tile_layer: TileLayer = layers[Layer.TILE]
	var pipe := Pipe.from_predata(input)
	tile_layer.place_tile(Vector2i(input.x, input.y), pipe)
	var colour_layer: ColourLayer = layers[Layer.COLOUR]
	colour_layer.set_tile_colour(Vector2i(input.x, input.y), input.colour, input)


func place_output(output: PreOutput):
	var tile_layer: TileLayer = layers[Layer.TILE]
	var pipe := Pipe.from_predata(output)
	tile_layer.place_tile(Vector2i(output.x, output.y), pipe)
	var colour_layer: ColourLayer = layers[Layer.COLOUR]
	colour_layer.set_tile_colour(Vector2i(output.x, output.y), output.colour, output)


func place_tile(pretile: PreTile):
	var tile_layer: TileLayer = layers[Layer.TILE]
	var pipe := Pipe.from_predata(pretile)
	tile_layer.place_tile(Vector2i(pretile.x, pretile.y), pipe)
	var colour_layer: ColourLayer = layers[Layer.COLOUR]
	colour_layer.update_at(Vector2i(pretile.x, pretile.y))


func clear_map() -> void:
	losing_outputs = {}
	_set_layer(BackgroundLayer.new(), Layer.BACKGROUND)
	_set_layer(ColourLayer.new(), Layer.COLOUR)
	_set_layer(TileLayer.new(), Layer.TILE)
	(layers[Layer.COLOUR] as ColourLayer).tile_layer = layers[Layer.TILE]


func draw_starting_map():
	clear_map()
	if !level_data:
		return
	var background_layer: BackgroundLayer = layers[Layer.BACKGROUND]
	background_layer.set_background(level_data.background)
	for input in level_data.inputs:
		place_input(input)
	for output in level_data.outputs:
		place_output(output)
	for other_tile in level_data.tiles:
		place_tile(other_tile)
	
	var dimensions := background_layer.get_used_rect().size
	scale = scale_from_dimensions(dimensions)
	position = Globals.WINDOW_SIZE / 2 - Vector2(
		dimensions.x * scale.x * Globals.TILE_SIZE / 2,
		dimensions.y * scale.y * Globals.TILE_SIZE / 2
	)
	
	is_running = true


func set_tile_at(tile_position):
	var tile_layer: TileLayer = layers[Layer.TILE]
	tile_layer.place_tile(tile_position, held_pipe)
	var colour_layer: ColourLayer = layers[Layer.COLOUR]
	colour_layer.update_at(tile_position)
	check_for_game_status()


func _mouse_position_to_coordinates() -> Vector2i:
	return layers[Layer.BACKGROUND].local_to_map(get_local_mouse_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !is_running:
		return
	
	if held_pipe != null:
		var hover_layer := layers[Layer.HOVER]
		hover_layer.clear()
		var target_cell := _mouse_position_to_coordinates()
		hover_layer.set_cell(target_cell, 0, held_pipe.get_coordinates(), held_pipe.alternative_id)
		if Input.is_action_just_released("RMB"):
			Sounds.play("turning")
			held_pipe.rotate()
		
		if Input.is_action_just_pressed("LMB"):
			var tile_position = _mouse_position_to_coordinates()
			var background_layer: BackgroundLayer = layers[Layer.BACKGROUND]
			if background_layer.is_background(tile_position):
				audio_stream_player.play()
				set_tile_at(tile_position)
			held_pipe = null


func animate_outputs(outputs: Array[Vector2i], animation_name: String) -> void:
	Sounds.play(animation_name)
	
	var animated_tiles: Array[AnimatedTile] = []
	for output in outputs:
		var a_tile := AnimatedTile.custom_new(layers[Layer.TILE], animation_name, output)
		animated_tiles.append(a_tile)
	
	match(animation_name):
		"winning":
			animated_tiles[0].animation_finished.connect(animation_winning_finished.emit)
		"losing":
			animated_tiles[0].animation_finished.connect(
				animation_losing_finished.emit.bind(losing_outputs))


# TODO replace with using Pipe
func is_output_filled(tile_coords: Vector2i) -> bool:
	var atlas_coords := layers[Layer.COLOUR].get_cell_atlas_coords(tile_coords)
	return atlas_coords == PipeData.output.filled_coord


func all_outputs_filled(outputs: Array[Vector2i]) -> bool:
	for output in outputs:
		if !is_output_filled(output):
			return false
	return true


func check_for_game_status():
	if not losing_outputs.is_empty():
		animate_outputs(losing_outputs.keys(), "losing")
		return
	
	var tile_layer: TileLayer = layers[Layer.TILE]
	if !all_outputs_filled(tile_layer.all_outputs()):
		return
	
	is_running = false
	
	level_won.emit()
	animate_outputs(tile_layer.all_outputs(), "winning")
