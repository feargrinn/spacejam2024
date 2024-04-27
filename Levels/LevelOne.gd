extends Map

class_name LevelOne

func set_dimensions():
	number_of_tiles_x = 7
	number_of_tiles_y = 3

func level_definition():
	var tile = t_tile_script.new()
	set_tile_at(tile, 3, 1, 2)
	tile = input_script.new(colour_script.new(1, 0, 0))
	set_tile_at(tile, 1, 0)
	tile = input_script.new(colour_script.new(0, 0, 1))
	set_tile_at(tile, 3, 0)
	tile = input_script.new(colour_script.new(0, 1, 0))
	set_tile_at(tile, 5, 0)
	tile = output_script.new(colour_script.new(1, 0, 1))
	set_tile_at(tile, 2, 2)
	tile = output_script.new(colour_script.new(0, 1, 1))
	set_tile_at(tile, 4, 2)
