extends TileMapLayer

class_name BackgroundLayer

const ALL_DIRECTIONS = [
	Vector2i(-1,-1),
	Vector2i(-1,0),
	Vector2i(-1,1),
	Vector2i(0,-1),
	Vector2i(0,1),
	Vector2i(1,-1),
	Vector2i(1,0),
	Vector2i(1,1)
]

const BACKGROUND_SPRITE_ID: Vector2i = Vector2i(0,0)

# gets global positions of cells surrounding cell at position pos
static func get_all_surrounding_cells(pos):
	var surrounding = []
	for offset in ALL_DIRECTIONS:
		surrounding.append(pos+offset)
	return surrounding

var has_background: Dictionary

func _init(background: Dictionary):
	name = "BackgroundLayer"
	self.tile_set = Globals.TILE_SET
	self.has_background = {}
	for background_cell in background.keys():
		set_background(background_cell)

# whether the given coordinates have a background
func is_background(pos: Vector2i) -> bool:
	return self.has_background.has(pos)

func is_ok_for_input_or_output(pos: Vector2i):
	if self.has_background.has(pos):
		return false
	else:
		var proper_alternatives = []
		for neighbour in get_surrounding_cells(pos):
			if self.has_background.has(neighbour):
				proper_alternatives.append(int(round(((Vector2(Vector2.UP).angle_to(neighbour-pos) + PI)/PI)*2))%4)
		proper_alternatives.sort()
		return proper_alternatives
	

func set_background(pos: Vector2i):
	if is_background(pos):
		# nothing to do
		return
	self.has_background[pos] = true
	set_cell(pos, 0, BACKGROUND_SPRITE_ID)
	_update_border_around(pos)

func delete_background(pos: Vector2i):
	if !is_background(pos):
		# nothing to do
		return
	self.has_background.erase(pos)
	erase_cell(pos)
	_update_border_around(pos)

# returns the directions in which the specified cell neighbours a background cell
func _background_cell_directions(pos: Vector2i) -> Array[Vector2i]:
	var border_neighbours: Array[Vector2i] = []
	for direction in ALL_DIRECTIONS:
		if self.is_background(pos + direction):
			border_neighbours.append(direction)
	return border_neighbours

# places a border sprite or removes any sprite if a border shouldn't be there
func _update_border_at(pos: Vector2i):
	# borders should only be painted over empty cells, not the background itself
	if self.is_background(pos):
		return
	var background_cells = _background_cell_directions(pos)
	var border_sprite = BorderSprite.with_background_neighbours(background_cells)
	if border_sprite is Error:
		erase_cell(pos)
	else:
		set_cell(pos, 0, border_sprite.get_sprite_pointer(), border_sprite.get_alternative())

# updates the borders around this
func _update_border_around(tile_pos: Vector2i):
	var surrounding = get_all_surrounding_cells(tile_pos)
	surrounding.append(tile_pos)
	for cell in surrounding:
		_update_border_at(cell)
