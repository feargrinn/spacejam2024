extends Map

class_name LevelThree

func set_dimensions():
	number_of_tiles_x = 11
	number_of_tiles_y = 11

func level_definition():
	var tile = t_tile_script.new()
	set_tile_at(tile, 3, 5, 1)