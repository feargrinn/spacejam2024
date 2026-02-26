class_name TileLayer
extends TileMapLayer

var inputs: Dictionary[Vector2i, Pipe]
var outputs: Dictionary[Vector2i, Pipe]
var pipes: Dictionary[Vector2i, Pipe]

var tiles: Dictionary[Vector2i, TileInteractor]


func empty_at(pos: Vector2i) -> bool:
	const EMPTY = Vector2i(-1,-1)
	return self.get_cell_atlas_coords(pos) == EMPTY


func get_pipe(pos: Vector2i) -> Pipe:
	if pipes.has(pos):
		return pipes[pos]
	return null


func _get_connections(pos: Vector2i) -> Array[Vector2i]:
	if empty_at(pos):
		return []
	return pipes[pos].get_connections()


func _get_flow_coefficient(pos: Vector2i) -> int:
	if empty_at(pos):
		return 0
	return pipes[pos].pipe_data.flow_coefficient


func _get_source_pipe(pos: Vector2i) -> SourcePipe:
	return SourcePipe.new(pos, _get_flow_coefficient(pos))


func _connects(pos: Vector2i, direction: Vector2i) -> bool:
	var other_connections = _get_connections(pos+direction)
	return other_connections.has(direction * -1)


func connected_pipes(pos: Vector2i) -> Array[SourcePipe]:
	var result: Array[SourcePipe] = []
	for connection in _get_connections(pos):
		if _connects(pos, connection):
			result.append(_get_source_pipe(pos+connection))
	return result


func valid_paint_source(pos: Vector2i) -> bool:
	return pipes[pos].pipe_data.paint_source


func place_tile(pos: Vector2i, pipe: Pipe):
	self.set_cell(pos, 0, pipe.get_coordinates(), pipe.alternative_id)
	var tile_interactor := TileInteractor.new(pos)
	tiles[pos] = tile_interactor
	pipes[pos] = pipe
	add_child(tile_interactor)
	if pipe.is_input():
		inputs[pos] = pipe
	if pipe.is_output():
		outputs[pos] = pipe


func continue_flow(pos: Vector2i) -> bool:
	return !pipes[pos].pipe_data.delayed_flow


func is_input(pos: Vector2i) -> bool:
	return inputs.has(pos)


func is_output(pos: Vector2i) -> bool:
	return outputs.has(pos)


func all_outputs() -> Array[Vector2i]:
	return outputs.keys()


func remove_tile(pos: Vector2i):
	self.erase_cell(pos)
