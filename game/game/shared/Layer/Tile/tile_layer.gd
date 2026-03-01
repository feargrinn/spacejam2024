class_name TileLayer
extends TileMapLayer


var outputs: Dictionary[Vector2i, Pipe]
var pipes: Dictionary[Vector2i, Pipe]


func _get_connections(pos: Vector2i) -> Array[Vector2i]:
	if empty_at(pos):
		return []
	return pipes[pos].get_connections()


func _connects(pos: Vector2i, direction: Vector2i) -> bool:
	var other_connections = _get_connections(pos+direction)
	return other_connections.has(direction * -1)


func connected_pipes(pos: Vector2i) -> Array[Pipe]:
	var result: Array[Pipe] = []
	for connection in _get_connections(pos):
		if _connects(pos, connection):
			result.append(get_pipe(pos+connection))
	return result


func empty_at(pos: Vector2i) -> bool:
	return !pipes.has(pos)


func get_pipe(pos: Vector2i) -> Pipe:
	if pipes.has(pos):
		return pipes[pos]
	return null


func place_tile(pos: Vector2i, pipe: Pipe):
	self.set_cell(pos, 0, pipe.get_coordinates(), pipe.alternative_id)
	pipes[pos] = pipe
	pipe.position = pos
	if pipe.is_output():
		outputs[pos] = pipe


func get_outputs() -> Array[Pipe]:
	return outputs.values()
