extends Map

class_name Level_08

func set_dimensions():
	number_of_tiles_x = 5
	number_of_tiles_y = 5

#tutorial for antipipe
func level_definition():
	var tile = input_script.new(colour_script.new(1, 1, 0))
	set_tile_at(tile, 2, 0, 0)

	tile = anti_tile_script.new()
	set_tile_at(tile, 2, 2, 1)

	tile = bend_tile_script.new()
	set_tile_at(tile, 1, 3, 1)

	tile = bend_tile_script.new()
	set_tile_at(tile, 2, 3, 2)

	tile = output_script.new(colour_script.new(0, 0, 0))
	set_tile_at(tile, 3, 4, 0)
