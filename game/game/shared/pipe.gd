class_name Pipe
extends Resource

var pipe_data: PipeData
var alternative_id: int
var colour: Colour
var target_colour: Colour
var position: Vector2i


static func from_predata(pre: RefCounted) -> Pipe:
	var pipe := Pipe.new()
	if pre is PreInput:
		pipe.pipe_data = PipeData.input
	elif pre is PreOutput:
		pipe.pipe_data = PipeData.output
	elif pre is PreTile:
		pipe.pipe_data = PipeData.get_by_coords(pre.type)
	
	pipe.alternative_id = pre.rot
	return pipe


func _to_string() -> String:
	return str(pipe_data) + " alt: " + str(alternative_id)


func rotate() -> void:
	alternative_id = (alternative_id + 1) % pipe_data.get_alternative_count()


func get_connections() -> Array[Vector2i]:
	var base_connections := pipe_data.get_connections()
	var rotated_connections: Array[Vector2i]
	for connection in base_connections:
		var f_v := Vector2(connection)
		f_v = f_v.rotated(PI/2 * alternative_id)
		rotated_connections.append(Vector2i(f_v.round()))
	return rotated_connections


func get_coordinates() -> Vector2i:
	return pipe_data.tileset_coordinates


func is_input() -> bool:
	return pipe_data == PipeData.input


func is_output() -> bool:
	return pipe_data == PipeData.output


## I have no clue why the normal duplicate() doesn't work???????? ;-;
func my_duplicate() -> Pipe:
	var pipe := Pipe.new()
	pipe.pipe_data = pipe_data
	pipe.alternative_id = alternative_id
	return pipe


func is_filled() -> bool:
	return colour != null
