class_name BorderHandler

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

# gets global positions of cells surrounding cell at position pos
static func get_all_surrounding_cells(pos):
	var surrounding = []
	for offset in ALL_DIRECTIONS:
		surrounding.append(pos+offset)
	return surrounding

# returns the directions in which the specified cell neighbours a background cell
static func background_cell_directions(layer, pos):
	var border_neighbours = []
	for direction in ALL_DIRECTIONS:
		if layer.get_cell_atlas_coords(pos + direction) == TileType.coordinates(TileType.Type.BACKGROUND):
			border_neighbours.append(direction)
	return border_neighbours

# places a border sprite or removes any sprite if a border shouldn't be there
static func update_border_at(layer, pos):
	# borders should only be painted over empty cells, not the background itself
	if layer.get_cell_atlas_coords(pos) == TileType.coordinates(TileType.Type.BACKGROUND):
		return
	var background_cells = background_cell_directions(layer, pos)
	var border_sprite = BorderSprite.with_background_neighbours(background_cells)
	if border_sprite is Error:
		layer.erase_cell(pos)
	else:
		layer.set_cell(pos, 0, border_sprite.get_sprite_pointer(), border_sprite.get_alternative())

# updates the borders around this
static func update_border_around(layer, tile_pos):
	var surrounding = get_all_surrounding_cells(tile_pos)
	surrounding.append(tile_pos)
	for cell in surrounding:
		update_border_at(layer, cell)
