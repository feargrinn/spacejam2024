#@tool
class_name PipeData
extends Resource

@export var texture: Texture
@export var tileset_coordinates: Vector2i
@export var connections: Dictionary[Vector2i, bool]
@export var delayed_flow := false
@export var paint_source := true
@export var flow_coefficient := 1

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


# Used only to improve quality of life when creating new PipeData resources
# Creates connections dictionary of correct size and keys,
# sets only orthogonal neighbours to true as connections.
# For it to work - uncomment code below as well as @tool at the top of this file
#func _init() -> void:
	#for i in 3:
		#for j in 3:
			#connections[Vector2i(i - 1, j - 1)] = !(abs(i - 1) == abs(j - 1))


func _to_string() -> String:
	var result := ""
	result += "coords: " + str(tileset_coordinates)
	result += " source: " + str(paint_source)
	result += " delayed: " + str(delayed_flow)
	result += " coefficient: " + str(flow_coefficient)
	return result


# connections is  Dict[Vector2i, bool], for quality of life purposes
# so this is used to return an array of existing connections
func get_connections() -> Array[Vector2i]:
	var existing := connections.keys().filter(func(key): return connections[key])
	return existing


func get_alternative_count() -> int:
	return Globals.TILE_SET.get_source(0).get_alternative_tiles_count(tileset_coordinates)
