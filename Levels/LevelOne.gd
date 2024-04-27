extends Map

class_name LevelOne

func _ready():
	var tile = t_tile_script.new()
	set_tile_at(tile, 3, 1, 1)
