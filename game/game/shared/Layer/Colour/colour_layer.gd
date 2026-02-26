class_name ColourLayer
extends TileMapLayer

var colour_coords = TileType.coordinates(TileType.Type.COLOR)

@export var tile_layer : TileLayer
var colours = {}


func set_tile_colour(tile_position, colour, input_or_output = null):
	if input_or_output:
		var alt_id: int
		if input_or_output is PreInput:
			alt_id = Colour.create_input_or_output_colour(TileType.Type.INPUT_COLOR, input_or_output.rot, colour.color())
			set_cell(tile_position, 0, TileType.coordinates(TileType.Type.INPUT_COLOR), alt_id)
		else:
			alt_id = Colour.create_input_or_output_colour(TileType.Type.OUTPUT_TARGET_COLOR, input_or_output.rot, colour.color())
			set_cell(tile_position, 0, TileType.coordinates(TileType.Type.OUTPUT_TARGET_COLOR), alt_id)
	else:
		set_cell(tile_position, 0, colour_coords, colour.colour_id)
	colours[tile_position] = colour

func is_painted(tile_position):
	return colours.has(tile_position)

func get_tile_colour(tile_position):
	return colours[tile_position]

func update_timestep(to_update: Array[Vector2i]) -> Array[Vector2i]:
	var update_in_next_step: Array[Vector2i] = []
	for location in to_update:
		var connected_pipes = tile_layer.connected_pipes(location)
		var empty_neighbours: Array[Vector2i] = []
		var full_neighbours: Array[Paint] = []
		for pipe in connected_pipes:
			if is_painted(pipe.position) && tile_layer.valid_paint_source(pipe.position):
				full_neighbours.append(Paint.new(get_tile_colour(pipe.position),pipe.flow_coefficient))
			else:
				empty_neighbours.append(pipe.position)
		if full_neighbours.any(func(paint): return paint.amount > 0):
			var colour = Paint.mix(full_neighbours)
			if tile_layer.is_output(location):
				var alternative_id = Colour.create_input_or_output_colour(TileType.Type.OUTPUT_FILLED, tile_layer.get_cell_alternative_tile(location), colour.color())
				var target_colour = get_tile_colour(location)
				set_cell(location, 0, TileType.coordinates(TileType.Type.OUTPUT_FILLED), alternative_id)
				if !target_colour.is_similar(colour):
					get_parent().losing_outputs[location] = {"target" : target_colour, "actual" : colour}
					get_parent().is_running = false
			else:
				set_tile_colour(location, colour)
			if tile_layer.continue_flow(location):
				update_in_next_step.append_array(empty_neighbours)
	return update_in_next_step


func update_at(pos : Vector2i):
	var to_update: Array[Vector2i] = [pos]
	while !to_update.is_empty():
		to_update = update_timestep(to_update)
