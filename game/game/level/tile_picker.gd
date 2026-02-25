class_name TilePicker
extends VBoxContainer


signal tile_picked_up(tile: TileId)


func _ready() -> void:
	for tile_type in TileType.pipe_types:
		var tile_button := _create_button(tile_type)
		add_child(tile_button)
		tile_button.tile_picked_up.connect(tile_picked_up.emit)


## Creates clickable tile buttons
func _create_button(tile_type: TileType.Type) -> PickableTile:
	var tile_coords := TileType.coordinates(tile_type)
	var texture: Texture = load(TileType.texture(tile_type))
	var container = PickableTile.create_scene(tile_coords, texture)
	return container
