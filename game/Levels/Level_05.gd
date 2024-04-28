extends Map

class_name Level_05

func set_dimensions():
	number_of_tiles_x = 4
	number_of_tiles_y = 3

func level_definition():
	var tile = input_script.new(colour_script.new(1, 1, 0))
	set_tile_at(tile, 1, 0, 0)
	tile = input_script.new(colour_script.new(0, 0, 1))
	set_tile_at(tile, 2, 0, 0)

	tile = output_script.new(colour_script.new(1, 1, 1))
	set_tile_at(tile, 1, 2)
	tile = output_script.new(colour_script.new(0, 0, 1))
	set_tile_at(tile, 2, 2)
