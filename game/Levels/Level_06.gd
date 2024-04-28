extends Map

class_name Level_06

func set_dimensions():
	number_of_tiles_x = 8
	number_of_tiles_y = 8

func level_definition():
	var tile = input_script.new(colour_script.new(1, 0, 0))
	set_tile_at(tile, 1, 0, 0)
	tile = input_script.new(colour_script.new(0, 1, 0))
	set_tile_at(tile, 3, 0, 0)
	tile = input_script.new(colour_script.new(1, 1, 1))
	set_tile_at(tile, 6, 0, 0)

	tile = output_script.new(colour_script.new(1, 1, 0))
	set_tile_at(tile, 1, 7)
	tile = output_script.new(colour_script.new(0, 1, 0))
	set_tile_at(tile, 3, 7)
	var paint : Array[Paint] = [Paint.new(colour_script.new(1,1,1), 1),Paint.new(colour_script.new(1,1,1), 1), Paint.new(colour_script.new(0,1,0), 1)]
	var result = Paint.mix(paint)
	tile = output_script.new(result)
	set_tile_at(tile, 6, 7)
