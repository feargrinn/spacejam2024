class_name Pipe
extends Resource

var pipe_data: PipeData
var alternative_id: int
var colour: Colour


static func from_predata(pre: RefCounted) -> Pipe:
	var pipe := Pipe.new()
	if pre is PreInput:
		pipe.pipe_data = PipeData.input
		pipe.colour = pre.colour
	elif pre is PreOutput:
		pipe.pipe_data = PipeData.output
		pipe.colour = pre.colour
	elif pre is PreTile:
		pipe.pipe_data = PipeData.get_by_coords(pre.type)
	
	pipe.alternative_id = pre.rot
	return pipe


func _to_string() -> String:
	return str(pipe_data) + " alt: " + str(alternative_id)


func rotate() -> void:
	alternative_id = (alternative_id + 1) % pipe_data.get_alternative_count()


func get_coordinates() -> Vector2i:
	return pipe_data.tileset_coordinates


func is_input() -> bool:
	return pipe_data == PipeData.input


func is_output() -> bool:
	return pipe_data == PipeData.output


#func is_filled() -> bool:
	#return colour != null
