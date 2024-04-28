extends Map

class_name Level_04

func set_dimensions():
	number_of_tiles_x = 5
	number_of_tiles_y = 4

func level_definition():
	var tile = input_script.new(colour_script.new(1, 0, 0))
	set_tile_at(tile, 1, 0, 0)
	tile = input_script.new(colour_script.new(1, 1, 1))
	set_tile_at(tile, 2, 3, 2)

	tile = straight_tile_script.new()
	set_tile_at(tile, 2, 2)

	tile = output_script.new(colour_script.new(1, 0, 0))
	set_tile_at(tile, 3, 3)
