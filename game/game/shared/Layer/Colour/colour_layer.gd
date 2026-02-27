class_name ColourLayer
extends TileMapLayer

signal lost(losing_outputs: Array[Pipe])
signal won

@export var tile_layer : TileLayer
var colours: Dictionary[Vector2i, Colour] = {}

var losing_outputs: Array[Pipe]


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


func is_painted(tile_position) -> bool:
	return colours.has(tile_position)


func get_tile_colour(tile_position) -> Colour:
	return colours[tile_position]


func update_timestep(to_update: Array[Pipe]) -> Array[Pipe]:
	var update_in_next_step: Array[Pipe] = []
	for pipe in to_update:
		var connected_pipes := tile_layer.connected_pipes(pipe.position)
		var empty_neighbours: Array[Pipe] = []
		var full_neighbours: Array[Pipe] = []
		for neighbour: Pipe in connected_pipes:
			if neighbour.is_filled() && neighbour.pipe_data.paint_source:
				full_neighbours.append(neighbour)
			else:
				empty_neighbours.append(neighbour)
		
		var neighbours_paint: Array[Paint] = []
		for neighbour in full_neighbours:
			neighbours_paint.append(neighbour.get_paint())
		
		if neighbours_paint.any(func(paint: Paint): return paint.amount > 0):
			var colour: Colour = Paint.mix(neighbours_paint)
			if pipe.is_output():
				set_tile_colour(pipe.position, colour)
				if !pipe.target_colour.is_similar(colour):
					losing_outputs.append(pipe)
			else:
				set_tile_colour(pipe.position, colour)
			if !pipe.pipe_data.delayed_flow:
				update_in_next_step.append_array(empty_neighbours)
	return update_in_next_step


func update_pipe(pipe : Pipe) -> void:
	var to_update: Array[Pipe] = [pipe]
	while !to_update.is_empty():
		to_update = update_timestep(to_update)
	if losing_outputs:
		lost.emit(losing_outputs)
		return
	
	for output in tile_layer.outputs.values():
		if !output.is_filled():
			return
	won.emit()
