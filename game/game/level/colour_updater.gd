class_name ColourUpdater
extends RefCounted

signal pipe_colour_set(pipe: Pipe)
signal outputs_correctly_filled(outputs: Array[Pipe])
signal outputs_incorrectly_filled(losing_outputs: Array[Pipe])

var pipes: Dictionary[Vector2i, Pipe]
var outputs: Array[Pipe]
var losing_outputs: Array[Pipe]


func _get_connections(pos: Vector2i) -> Array[Vector2i]:
	if !pipes.has(pos):
		return []
	return pipes[pos].get_connections()


func _connects(pos: Vector2i, direction: Vector2i) -> bool:
	var other_connections = _get_connections(pos+direction)
	return other_connections.has(direction * -1)


func _connected_pipes(pos: Vector2i) -> Array[Pipe]:
	var result: Array[Pipe] = []
	for connection in _get_connections(pos):
		if _connects(pos, connection):
			result.append(pipes[pos+connection])
	return result


func _update_timestep(to_update: Array[Pipe]) -> Array[Pipe]:
	var update_in_next_step: Array[Pipe] = []
	for pipe in to_update:
		var connected_pipes := _connected_pipes(pipe.position)
		var empty_neighbours: Array[Pipe] = []
		var full_neighbours: Array[Pipe] = []
		for neighbour: Pipe in connected_pipes:
			if neighbour.is_filled() && neighbour.is_paint_source():
				full_neighbours.append(neighbour)
			else:
				empty_neighbours.append(neighbour)
		
		var neighbours_paint: Array[Paint] = []
		for neighbour in full_neighbours:
			neighbours_paint.append(neighbour.get_paint())
		
		if neighbours_paint.any(func(paint: Paint): return paint.amount > 0):
			var colour: Colour = Paint.mix(neighbours_paint)
			pipe.colour = colour
			pipe_colour_set.emit(pipe)
			if !pipe.is_filled_acceptably():
				losing_outputs.append(pipe)
			if pipe.should_continue_flow():
				update_in_next_step.append_array(empty_neighbours)
	return update_in_next_step


func update_pipe(pipe : Pipe) -> void:
	var to_update: Array[Pipe] = [pipe]
	while !to_update.is_empty():
		to_update = _update_timestep(to_update)
	
	if losing_outputs:
		outputs_incorrectly_filled.emit(losing_outputs)
		return
	
	if !outputs:
		return
	
	if outputs.all(func(output: Pipe): return output.is_filled()):
		outputs_correctly_filled.emit(outputs)


func register_pipe(pipe: Pipe) -> void:
	pipes[pipe.position] = pipe
	if pipe.is_output():
		outputs.append(pipe)
	update_pipe(pipe)
