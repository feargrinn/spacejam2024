extends Map

class_name LevelTwo

func _ready():
	var tile = t_tile_script.new()
	set_tile_at(tile, 3, 2, 1)
