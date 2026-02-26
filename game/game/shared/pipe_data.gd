@tool
class_name PipeData
extends Resource

@export var texture: Texture
@export var tileset_coordinates: Vector2i
@export var connections: Dictionary[Vector2i, bool]

@export_category("Colour")
@export var empty_coords := Vector2i(-1, -1)
@export var filled_coord := Vector2i(5, 1)


static var input: PipeData = load("res://game/shared/pipes/input.tres")
static var output: PipeData = load("res://game/shared/pipes/output.tres")
static var pipes: Array[PipeData] = [
	load("res://game/shared/pipes/i_pipe.tres"),
	load("res://game/shared/pipes/t_pipe.tres"),
	load("res://game/shared/pipes/l_pipe.tres"),
	load("res://game/shared/pipes/cross_pipe.tres"),
	load("res://game/shared/pipes/anti_pipe.tres"),
]


static func get_by_coords(coords: Vector2i) -> PipeData:
	for pipe: PipeData in pipes:
		if pipe.tileset_coordinates == coords:
			return pipe
	return null


func _init() -> void:
	for i in 3:
		for j in 3:
			connections[Vector2i(i - 1, j - 1)] = !(abs(i - 1) == abs(j - 1))


func _to_string() -> String:
	return str(tileset_coordinates) + " : " + str(get_connections())


func get_connections() -> Array[Vector2i]:
	var existing := connections.keys().filter(func(key): return connections[key])
	return existing


func get_alternative_count() -> int:
	return Globals.TILE_SET.get_source(0).get_alternative_tiles_count(tileset_coordinates)
