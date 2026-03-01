class_name ColourLayer
extends TileMapLayer


func set_tile_colour(pipe: Pipe) -> void:
	var tile_coords := pipe.get_filled_colour_coords()
	var alt_id := Colour.create_tile_colour(
		tile_coords, 
		pipe.alternative_id, 
		pipe.get_color())
	
	set_cell(pipe.position, 0, tile_coords, alt_id)


func set_target_colour(output: Pipe) -> void:
	var tile_coords := output.get_empty_colour_coords()
	var alt_id := Colour.create_tile_colour(
		tile_coords, 
		output.alternative_id, 
		output.get_target_color())
	
	set_cell(output.position, 0, tile_coords, alt_id)
