class_name TileId

var id: Vector2i
var alternative: int

func _init(a_id: Vector2i, a_alternative: int):
	self.id = a_id
	self.alternative = a_alternative % _total_alternatives()

func _total_alternatives() -> int:
	if id == Vector2i(-1, -1):
		return 1
	return Globals.TILE_SET.get_source(0).get_alternative_tiles_count(id)

func rotate():
	self.alternative = (self.alternative + 1) % _total_alternatives()
