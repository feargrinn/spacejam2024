@tool
class_name LevelTileMap
extends OurTileMap

signal level_won
signal animation_losing_finished(losing_outputs: Array[Pipe])
signal animation_winning_finished

# The stream player still shouldn't be here I think, but it's better
@onready var audio_stream_player: AudioStreamPlayer = $PipePlaceStreamPlayer


func _on_level_lost(losing_outputs: Array[Pipe]) -> void:
	var animation := animate_outputs(losing_outputs, "losing")
	animation.animation_finished.connect(
		animation_losing_finished.emit.bind(losing_outputs)
	)
	hover_layer.clear()


func _on_level_won(outputs: Array[Pipe]) -> void:
	level_won.emit()
	var animation := animate_outputs(outputs, "winning")
	animation.animation_finished.connect(animation_winning_finished.emit)


func _scale_from_dimensions(dimensions: Vector2i) -> Vector2:
	if max(dimensions.x, dimensions.y) <= 10:
		return Vector2(2, 2)
	else:
		return Vector2(1, 1)


func _place_held_pipe() -> void:
	var mouse_position := get_local_mouse_position()
	var mouse_coords := background_layer.local_to_map(mouse_position)
	
	if !background_layer.is_background(mouse_coords):
		reset_held_pipe()
		return
	
	tile_layer.place_pipe(mouse_coords, held_pipe)
	audio_stream_player.play()
	colour_updater.register_pipe(held_pipe)
	colour_updater.check_status()
	reset_held_pipe()


func animate_outputs(outputs: Array[Pipe], animation_name: String) -> AnimatedTile:
	Sounds.play(animation_name)
	
	var animated_tiles: Array[AnimatedTile] = []
	for output in outputs:
		var animated_tile := AnimatedTile.new(animation_name)
		add_child(animated_tile)
		animated_tile.position = background_layer.map_to_local(output.position)
		animated_tile.rotation = output.alternative_id * PI/2
		animated_tiles.append(animated_tile)
	
	return animated_tiles[0]


func reset() -> void:
	super.reset()
	colour_updater.outputs_correctly_filled.connect(_on_level_won)
	colour_updater.outputs_incorrectly_filled.connect(_on_level_lost)


func set_level(level: Level) -> void:
	level_data = level
	if is_node_ready():
		draw_starting_map()
	else:
		ready.connect(draw_starting_map)


func draw_starting_map():
	draw_level()
	
	var dimensions := background_layer.get_used_rect().size
	scale = _scale_from_dimensions(dimensions)
	position = Globals.WINDOW_SIZE / 2 - Vector2(
		dimensions.x * scale.x * Globals.TILE_SIZE / 2,
		dimensions.y * scale.y * Globals.TILE_SIZE / 2
	)
