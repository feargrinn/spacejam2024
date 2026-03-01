class_name LevelTileMap
extends Node2D

signal level_won
signal animation_losing_finished(losing_outputs: Array[Pipe])
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


var held_pipe: Pipe = null
var level_name: String
var colour_updater: ColourUpdater


@onready var layers: Dictionary[Layer, TileMapLayer] = {
	Layer.BACKGROUND : %BackgroundLayer,
	Layer.COLOUR : %ColourLayer,
	Layer.TILE : %TileLayer,
	Layer.HOVER : %TileHoverLayer
}

# The stream player still shouldn't be here I think, but it's better
@onready var audio_stream_player: AudioStreamPlayer = $RotateStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	colour_updater = ColourUpdater.new()
	colour_updater.outputs_correctly_filled.connect(_on_level_won)
	colour_updater.outputs_incorrectly_filled.connect(_on_level_lost)
	colour_updater.pipe_colour_set.connect(
		(layers[Layer.COLOUR] as ColourLayer).set_tile_colour)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if held_pipe != null:
		var hover_layer := layers[Layer.HOVER]
		hover_layer.clear()
		var target_cell := _mouse_position_to_coordinates()
		hover_layer.set_cell(target_cell, 0, held_pipe.get_coordinates(), held_pipe.alternative_id)
		if Input.is_action_just_released("RMB"):
			Sounds.play("turning")
			held_pipe.rotate()
		
		if Input.is_action_just_pressed("LMB"):
			var background_layer: BackgroundLayer = layers[Layer.BACKGROUND]
			if background_layer.is_background(target_cell):
				audio_stream_player.play()
				set_tile_at(target_cell)
			held_pipe = null
			hover_layer.clear()


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


func _on_level_lost(losing_outputs: Array[Pipe]) -> void:
	var animation := animate_outputs(losing_outputs, "losing")
	animation.animation_finished.connect(
		animation_losing_finished.emit.bind(losing_outputs)
	)
	layers[Layer.HOVER].clear()


func _on_level_won(outputs: Array[Pipe]) -> void:
	level_won.emit()
	var animation := animate_outputs(outputs, "winning")
	animation.animation_finished.connect(animation_winning_finished.emit)


func _scale_from_dimensions(dimensions: Vector2i) -> Vector2:
	if max(dimensions.x, dimensions.y) <= 10:
		return Vector2(2, 2)
	else:
		return Vector2(1, 1)


func _mouse_position_to_coordinates() -> Vector2i:
	return layers[Layer.BACKGROUND].local_to_map(get_local_mouse_position())


func set_level(level: Level) -> void:
	level_data = level
	if is_node_ready():
		draw_starting_map()
	else:
		ready.connect(draw_starting_map)


func set_held_tile(pipe: Pipe) -> void:
	held_pipe = pipe


func place_input(input: PreInput):
	var tile_layer: TileLayer = layers[Layer.TILE]
	var pipe := Pipe.from_predata(input)
	tile_layer.place_pipe(Vector2i(input.x, input.y), pipe)
	var colour_layer: ColourLayer = layers[Layer.COLOUR]
	pipe.colour = input.colour
	colour_updater.register_pipe(pipe)
	colour_layer.set_tile_colour(pipe)
	var hover_layer: HoverLayer = layers[Layer.HOVER]
	hover_layer.set_interactor(Vector2i(input.x, input.y))


func place_output(output: PreOutput):
	var tile_layer: TileLayer = layers[Layer.TILE]
	var pipe := Pipe.from_predata(output)
	tile_layer.place_pipe(Vector2i(output.x, output.y), pipe)
	var colour_layer: ColourLayer = layers[Layer.COLOUR]
	pipe.target_colour = output.colour
	colour_updater.register_pipe(pipe)
	colour_layer.set_target_colour(pipe)
	var hover_layer: HoverLayer = layers[Layer.HOVER]
	hover_layer.set_interactor(Vector2i(output.x, output.y))


func place_tile(pretile: PreTile):
	var tile_layer: TileLayer = layers[Layer.TILE]
	var pipe := Pipe.from_predata(pretile)
	tile_layer.place_pipe(Vector2i(pretile.x, pretile.y), pipe)
	colour_updater.register_pipe(pipe)
	var hover_layer: HoverLayer = layers[Layer.HOVER]
	hover_layer.set_interactor(Vector2i(pretile.x, pretile.y))


func clear_map() -> void:
	_set_layer(BackgroundLayer.new(), Layer.BACKGROUND)
	var colour_layer := ColourLayer.new()
	_set_layer(colour_layer, Layer.COLOUR)
	_set_layer(TileLayer.new(), Layer.TILE)
	_set_layer(HoverLayer.new(), Layer.HOVER)
	colour_updater = ColourUpdater.new()
	colour_updater.outputs_correctly_filled.connect(_on_level_won)
	colour_updater.outputs_incorrectly_filled.connect(_on_level_lost)
	colour_updater.pipe_colour_set.connect(colour_layer.set_tile_colour)


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
	scale = _scale_from_dimensions(dimensions)
	position = Globals.WINDOW_SIZE / 2 - Vector2(
		dimensions.x * scale.x * Globals.TILE_SIZE / 2,
		dimensions.y * scale.y * Globals.TILE_SIZE / 2
	)


func set_tile_at(tile_position):
	var tile_layer: TileLayer = layers[Layer.TILE]
	tile_layer.place_pipe(tile_position, held_pipe)
	colour_updater.register_pipe(held_pipe)


func animate_outputs(outputs: Array[Pipe], animation_name: String) -> AnimatedTile:
	Sounds.play(animation_name)
	
	var animated_tiles: Array[AnimatedTile] = []
	for output in outputs:
		var animated_tile := AnimatedTile.new(animation_name)
		add_child(animated_tile)
		animated_tile.position = layers[Layer.BACKGROUND].map_to_local(output.position)
		animated_tile.rotation = output.alternative_id * PI/2
		animated_tiles.append(animated_tile)
	
	return animated_tiles[0]
