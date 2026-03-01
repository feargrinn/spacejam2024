class_name TilePicker
extends VBoxContainer

signal tile_picked_up(pipe: Pipe)


func _ready() -> void:
	for pipe_data: PipeData in PipeData.pipes:
		var pipe := Pipe.new()
		pipe.pipe_data = pipe_data
		var tile_button := _create_button(pipe)
		add_child(tile_button)
		tile_button.tile_picked_up.connect(tile_picked_up.emit)


## Creates clickable tile buttons
func _create_button(pipe: Pipe) -> PickableTile:
	var container = PickableTile.create_scene(pipe)
	return container
