class_name BorderHandler

const vectors_to_surrounding_cells = [Vector2i(-1,-1), Vector2i(0,-1), Vector2i(1,-1),
	Vector2i(-1,0), Vector2i(1,0),
	Vector2i(-1,1), Vector2i(0,1), Vector2i(1,1)]

# gets global positions of cells surrounding cell at position pos
static func get_all_surrounding_cells(pos):
	var surrounding = vectors_to_surrounding_cells.duplicate(true)
	for i in range(surrounding.size()):
		surrounding[i] += pos
	return surrounding
			
# gets directional vectors to tiles which have a background cell, for a specific tile in tilemap
static func get_cell_vectors(pos, alt):
	if !Globals.TILE_SET.get_source(0).has_alternative_tile(pos, alt):
		return []
	var cell_data = Globals.TILE_SET.get_source(0).get_tile_data(pos, alt)
	var cell_directions = []
	for i in range(vectors_to_surrounding_cells.size()):
		if cell_data.get_custom_data_by_layer_id(i):
			cell_directions.append(vectors_to_surrounding_cells[i])
	return cell_directions

# if there is a tile up, the tiles up-left and up-right don't matter, that's why it doesn't need to perfectly match
static func visually_equals(required_neighbours, potentially_fitting_cell_neighbours):
	var base_directions = []
	for direction in required_neighbours:
		if direction.length() == 1:
			base_directions.append(direction)
	var directions_to_check = get_all_surrounding_cells(Vector2i.ZERO)
	for direction in base_directions:
		if !potentially_fitting_cell_neighbours.has(direction):
			return false
		else:
			directions_to_check.erase(direction)
			directions_to_check.erase(direction + Vector2i(direction.y, direction.x))
			directions_to_check.erase(direction - Vector2i(direction.y, direction.x))
	for direction in directions_to_check:
		if !(required_neighbours.has(direction) == potentially_fitting_cell_neighbours.has(direction)):
			return false
	return true

# finds an appropriate border given directions from tile to background tiles (not borders)
static func search_for_border(directions):
	for i in range(13):
		var amount_of_alternatives = Globals.TILE_SET.get_source(0).get_alternative_tiles_count(Vector2i(i,2))
		for j in range(amount_of_alternatives):
			if visually_equals(directions, get_cell_vectors(Vector2i(i,2),j)):
				return [Vector2i(i,2), j]
	return []
	
# places a border tile or empty tile if not found
static func put_border(layer, pos, surroundings):
	var border_coords = search_for_border(surroundings)
	if !border_coords == []:
		layer.set_cell(pos, 0, border_coords[0], border_coords[1])
	else:
		layer.erase_cell(pos)
			
			
static func get_cell_surroundings(layer, pos):
	var neighbours = get_all_surrounding_cells(pos)
	var border_neighbours = []
	for neighbour in neighbours:
		if layer.get_cell_atlas_coords(neighbour) == TileType.BACKGROUND():
			border_neighbours.append(neighbour - pos) 
	return border_neighbours
	
static func update_surrounding_background(layer, tile_pos):
	var surrounding = get_all_surrounding_cells(tile_pos)
	for cell in surrounding:
		if layer.get_cell_atlas_coords(cell) != TileType.BACKGROUND():
			var neighbours = get_cell_surroundings(layer, cell)
			put_border(layer, cell, neighbours)
