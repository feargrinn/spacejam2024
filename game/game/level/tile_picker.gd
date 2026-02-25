class_name TilePicker
extends VBoxContainer


signal tile_picked_up(tile: TileId)


func _ready() -> void:
	for pipe: PipeData in PipeData.pipes.values():
		var tile_button := _create_button(pipe)
		add_child(tile_button)
		tile_button.tile_picked_up.connect(tile_picked_up.emit)


## Creates clickable tile buttons
func _create_button(pipe: PipeData) -> PickableTile:
	var tile_coords := pipe.tileset_coordinates
	var texture := pipe.texture
	var container = PickableTile.create_scene(tile_coords, texture)
	return container
