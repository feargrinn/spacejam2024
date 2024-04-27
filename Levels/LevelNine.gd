extends Map

class_name LevelNine

func set_dimensions():
	number_of_tiles_x = 5
	number_of_tiles_y = 5

func level_definition():
	var tile = input_script.new(colour_script.new(1, 1, 1))
	set_tile_at(tile, 2, 0, 0)
	tile = input_script.new(colour_script.new(0, 0, 1))
	set_tile_at(tile, 0, 1, 3)
	tile = input_script.new(colour_script.new(0, 0, 0))
	set_tile_at(tile, 0, 2, 3)
	tile = input_script.new(colour_script.new(1, 0, 0))
	set_tile_at(tile, 4, 1, 1)
	tile = input_script.new(colour_script.new(1, 1, 1))
	set_tile_at(tile, 4, 3, 1)

	var paint : Array[Paint] = [Paint.new(colour_script.new(1,1,1), 1), Paint.new(colour_script.new(0,1,0), 1)]
	var result = Paint.mix(paint)
	tile = output_script.new(result)
	set_tile_at(tile, 4, 2, 3)
	
	paint = [Paint.new(colour_script.new(0,0,0), 1), Paint.new(colour_script.new(0,1,0), 1)]
	result = Paint.mix(paint)
	tile = output_script.new(result)
	set_tile_at(tile, 0, 3, 1)
