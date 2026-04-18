@tool
class_name BorderData
extends Resource

enum Direction{
	RIGHT,
	RIGHT_DOWN,
	DOWN,
	LEFT_DOWN,
	LEFT,
	LEFT_UP,
	UP,
	RIGHT_UP
}


const DIRECTION_VECTORS: Dictionary[Direction, Vector2i] = {
	Direction.RIGHT : Vector2i.RIGHT,
	Direction.RIGHT_DOWN : Vector2i(1, 1),
	Direction.DOWN : Vector2i.DOWN,
	Direction.LEFT_DOWN : Vector2i(-1, 1),
	Direction.LEFT : Vector2i.LEFT,
	Direction.LEFT_UP : Vector2i(-1, -1),
	Direction.UP : Vector2i.UP,
	Direction.RIGHT_UP : Vector2i(1, -1)
}

@export_range(0, 32) var tileset_id: int
# Making sure there are no duplicates
@export var borders: Array[Direction]:
	set(new_borders):
		borders = []
		for value in new_borders:
			if !borders.has(value):
				borders.append(value)
		borders.sort()
		changed.emit()
@export_range(0, 3) var alternatives := 3
@export var requires_mirror := false


func _to_string() -> String:
	return str(borders) + " alt: %s mirror: %s" % [alternatives, requires_mirror]


func _is_orthogonal(direction: Direction) -> bool:
	return DIRECTION_VECTORS[direction].length_squared() == 1


func _get_orthogonal() -> Array[Direction]:
	var orthogonal: Array[Direction] = []
	for key in DIRECTION_VECTORS:
		if _is_orthogonal(key):
			orthogonal.append(key)
	return orthogonal


func _get_diagonal() -> Array[Direction]:
	var orthogonal := _get_orthogonal()
	var all := DIRECTION_VECTORS.keys()
	for direction in orthogonal:
		all.erase(direction)
	return all


func _filter_orthogonal(values: Array[Direction]) -> Array[Direction]:
	return values.filter(_is_orthogonal)


func _is_corner_specified(direction: Direction) -> bool:
	var vector := DIRECTION_VECTORS[direction]
	var x_comp := Vector2i(vector.x, 0)
	var y_comp := Vector2i(0, vector.y)
	
	var border_directions: Array[Vector2i] = []
	for border in borders:
		border_directions.append(DIRECTION_VECTORS[border])
	
	return !border_directions.has(x_comp) and !border_directions.has(y_comp)


func _get_corner_requirement(direction: Direction) -> bool:
	return borders.has(direction)


func _calculate_required_neighbours() -> Dictionary[Direction, bool]:
	var required_neighbours: Dictionary[Direction, bool] = {}
	var all_orthogonal := _get_orthogonal()
	
	for orthogonal in all_orthogonal:
		required_neighbours[orthogonal] = orthogonal in borders
	
	var all_diagonal := _get_diagonal()
	for diagonal in all_diagonal:
		if _is_corner_specified(diagonal):
			required_neighbours[diagonal] = _get_corner_requirement(diagonal)
	
	return required_neighbours


func get_neighbour_requirements(alternative := 0) -> Dictionary[Vector2i, bool]:
	var base_requirements := _calculate_required_neighbours()
	
	var rotated_requirements: Dictionary[Vector2i, bool] = {}
	
	for key in base_requirements:
		var new_key := (key + 2 * alternative) % Direction.size()
		rotated_requirements[DIRECTION_VECTORS[new_key]] = base_requirements[key]
	
	return rotated_requirements
