class_name TileLayer
extends TileMapLayer

var pipes: Dictionary[Vector2i, Pipe]


func place_pipe(pos: Vector2i, pipe: Pipe, can_on_top := false) -> bool:
	if !can_on_top and pipes.has(pos):
		return false
	set_cell(pos, 0, pipe.get_coordinates(), pipe.alternative_id)
	pipes[pos] = pipe
	pipe.position = pos
	return true
