extends Map

class_name LevelOne

func level_definition():
	for i in range(1, number_of_tiles - 1):
		set_tile_at(no_tile_script.new(), 0, i)
		set_tile_at(no_tile_script.new(), number_of_tiles-1, i)
		set_tile_at(no_tile_script.new(), i, 0)
		set_tile_at(no_tile_script.new(), i, number_of_tiles-1)

	set_tile_at(no_tile_script.new(), 0, 0)
	set_tile_at(no_tile_script.new(), number_of_tiles-1, 0)
	set_tile_at(no_tile_script.new(), number_of_tiles-1, number_of_tiles-1)
	set_tile_at(no_tile_script.new(), 0, number_of_tiles-1)

	var tile = t_tile_script.new()
	set_tile_at(tile, 3, 1, 2)
	tile = input_script.new(colour_script.new(1, 0, 0))
	set_tile_at(tile, 1, 0)
	tile = input_script.new(colour_script.new(0, 0, 1))
	set_tile_at(tile, 3, 0)
	tile = input_script.new(colour_script.new(0, 1, 0))
	set_tile_at(tile, 5, 0)
