class_name ColourLayer
extends TileMapLayer

signal lost(losing_outputs: Dictionary[Vector2i, Dictionary])
signal won

@export var tile_layer : TileLayer
var colours: Dictionary[Vector2i, Colour] = {}

var losing_outputs: Dictionary[Vector2i, Dictionary]


func set_tile_colour(tile_position: Vector2i, colour: Colour) -> void:
	var pipe := tile_layer.get_pipe(tile_position)
	var alt_id: int
	var tile_coords: Vector2i
	
	if pipe.is_output() and !pipe.target_colour:
		tile_coords = pipe.pipe_data.empty_coords
		pipe.target_colour = colour
	else:
		tile_coords = pipe.pipe_data.filled_coord
		pipe.colour = colour
	
	alt_id = Colour.create_tile_colour(tile_coords, pipe.alternative_id, colour.color())
	set_cell(tile_position, 0, tile_coords, alt_id)
	colours[tile_position] = colour


func is_painted(tile_position):
	return colours.has(tile_position)


func get_tile_colour(tile_position):
	return colours[tile_position]


func update_timestep(to_update: Array[Vector2i]) -> Array[Vector2i]:
	var update_in_next_step: Array[Vector2i] = []
	for location in to_update:
		var connected_pipes := tile_layer.connected_pipes(location)
		var empty_neighbours: Array[Vector2i] = []
		var full_neighbours: Array[Paint] = []
		for pipe: SourcePipe in connected_pipes:
			if is_painted(pipe.position) && tile_layer.valid_paint_source(pipe.position):
				full_neighbours.append(Paint.new(get_tile_colour(pipe.position),pipe.flow_coefficient))
			else:
				empty_neighbours.append(pipe.position)
		if full_neighbours.any(func(paint): return paint.amount > 0):
			var colour: Colour = Paint.mix(full_neighbours)
			if tile_layer.is_output(location):
				var target_colour = get_tile_colour(location)
				set_tile_colour(location, colour)
				if !target_colour.is_similar(colour):
					losing_outputs[location] = {"target" : target_colour, "actual" : colour}
			else:
				set_tile_colour(location, colour)
			if tile_layer.continue_flow(location):
				update_in_next_step.append_array(empty_neighbours)
	return update_in_next_step


func update_at(pos : Vector2i) -> void:
	var to_update: Array[Vector2i] = [pos]
	while !to_update.is_empty():
		to_update = update_timestep(to_update)
	if losing_outputs:
		lost.emit(losing_outputs)
		return
	
	for pipe in tile_layer.outputs.values():
		if !pipe.is_filled():
			return
	won.emit()
