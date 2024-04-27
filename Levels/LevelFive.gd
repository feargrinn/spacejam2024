extends Map

class_name LevelFive

func _ready():
	var tile = t_tile_script.new()
	set_tile_at(tile, 2, 2, 3)
