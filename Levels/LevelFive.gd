extends Map

class_name LevelFive

func set_dimensions():
	number_of_tiles_x = 4
	number_of_tiles_y = 4

func level_definition():
	var tile = input_script.new(colour_script.new(0, 1, 0))
	set_tile_at(tile, 1, 0, 0)
	tile = input_script.new(colour_script.new(1, 0, 0))
	set_tile_at(tile, 3, 1, 1)
	tile = input_script.new(colour_script.new(1, 1, 0))
	set_tile_at(tile, 2, 3, 2)
	tile = input_script.new(colour_script.new(0, 0, 1))
	set_tile_at(tile, 0, 2, 3)
	tile = output_script.new(colour_script.new(1, 1, 0))
	set_tile_at(tile, 3, 2, 3)
	all_outputs.append(tile)
	tile = output_script.new(colour_script.new(1, 1, 1))
	set_tile_at(tile, 1, 3)
	all_outputs.append(tile)
