class_name TileLayer
extends TileMapLayer


var inputs: Array[Vector2i]
var outputs: Array[Vector2i]

const EMPTY = Vector2i(-1,-1)
const INPUT = Vector2i(0,1)
const OUTPUT = Vector2i(1,1)

var tiles: Array[TileInteractor]

func _ready() -> void:
	TileInteractor.tile_layer = self


func clear_data() -> void:
	for tile in tiles:
		tile.queue_free()
	tiles = []
	inputs = []
	outputs = []


func empty_at(pos: Vector2i) -> bool:
	return self.get_cell_atlas_coords(pos) == EMPTY

func _get_data(pos: Vector2i) -> TileData:
	return self.get_cell_tile_data(pos)

func _get_connections(pos: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	if empty_at(pos):
		return result
	for connection in _get_data(pos).get_custom_data("connections").keys():
		result.append(connection)
	return result

func _get_flow_coefficient(pos: Vector2i) -> int:
	if empty_at(pos):
		return 0
	return _get_data(pos).get_custom_data("flow_coefficient")

func _get_source_pipe(pos: Vector2i) -> SourcePipe:
	return SourcePipe.new(pos, _get_flow_coefficient(pos))

func _connects(pos: Vector2i, direction: Vector2i):
	var other_connections = _get_connections(pos+direction)
	return other_connections.has(direction * -1)

func connected_pipes(pos: Vector2i) -> Array[SourcePipe]:
	var result: Array[SourcePipe] = []
	for connection in _get_connections(pos):
		if _connects(pos, connection):
			result.append(_get_source_pipe(pos+connection))
	return result

func valid_paint_source(pos: Vector2i) -> bool:
	return _get_data(pos).get_custom_data("paint_source")

func place_tile(pos: Vector2i, tile: TileId):
	self.set_cell(pos, 0, tile.id, tile.alternative)
	var l_tile = TileInteractor.new(pos)
	tiles.append(l_tile)
	add_child(l_tile)
	if tile.id == INPUT:
		inputs.append(pos)
	if tile.id == OUTPUT:
		outputs.append(pos)

func continue_flow(pos: Vector2i) -> bool:
	return !_get_data(pos).get_custom_data("delayed_flow")

func is_input(pos: Vector2i) -> bool:
	return inputs.has(pos)

func is_output(pos: Vector2i) -> bool:
	return outputs.has(pos)

func all_outputs() -> Array[Vector2i]:
	return outputs

func remove_tile(pos: Vector2i):
	self.erase_cell(pos)
