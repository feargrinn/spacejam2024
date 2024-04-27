extends Map

class_name LevelOne

func set_dimensions():
	number_of_tiles_x = 3
	number_of_tiles_y = 3

func level_definition():
	var tile = input_script.new(colour_script.new(1, 0, 0))
	set_tile_at(tile, 0, 1, 3)
	tile = output_script.new(colour_script.new(1, 0, 0))
	set_tile_at(tile, 2, 1, 3)
