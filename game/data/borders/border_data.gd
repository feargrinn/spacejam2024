@tool
class_name BorderData
extends Resource
## This class is responsible for keeping data that's shared by all alternative
## border tiles on a specific position in tileset.

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

static var BORDER_ROW := 2

@export_range(0, 32) var tileset_id: int:
	set(value):
		tileset_id = value
		tileset_coords = Vector2i(tileset_id, BORDER_ROW)
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

var tileset_coords: Vector2i


static func empty() -> BorderData:
	var b_d := BorderData.new()
	b_d.alternatives = 0
	b_d.tileset_coords = -Vector2i.ONE
	return b_d


func _init() -> void:
	tileset_coords = Vector2i(tileset_id, BORDER_ROW)


func _to_string() -> String:
	var border_names: Array[String]
	for border in borders:
		border_names.append(Direction.keys()[border])
	return str(border_names) + " alt: %s mirror: %s" % [alternatives, requires_mirror]


func _is_orthogonal(direction: Direction) -> bool:
	return DIRECTION_VECTORS[direction].length_squared() == 1


func _get_orthogonal() -> Array[Direction]:
	return _filter_orthogonal(DIRECTION_VECTORS.keys())


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
