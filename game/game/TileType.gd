class_name  TileType

enum Type {
	EMPTY,
	BACKGROUND,
	INPUT,
	INPUT_COLOR,
	OUTPUT,
	OUTPUT_TARGET_COLOR,
	OUTPUT_FILLED,
	COLOR,
	ERASER,
	MAX_TYPES,
}


static func is_input_or_output(tile_coords : Vector2i):
	var types = [Type.INPUT, Type.OUTPUT]
	var type_coordinates = []
	types.all(func(type): type_coordinates.append(coordinates(type)); return true)
	return type_coordinates.has(tile_coords)


static func id_from_coordinates(a_coordinates : Vector2i) -> Type:
	for element in Type:
		if coordinates(Type[element]) == a_coordinates:
			return Type[element]
	return Type.ERASER

static func coordinates(tile_type : Type) -> Vector2i:
	match tile_type:
		Type.EMPTY:
			return Vector2i(-1,-1)
		Type.BACKGROUND:
			return Vector2i(0,0)
		Type.INPUT:
			return Vector2i(0,1)
		Type.INPUT_COLOR:
			return Vector2i(2,1)
		Type.OUTPUT:
			return Vector2i(1,1)
		Type.OUTPUT_TARGET_COLOR:
			return Vector2i(3,1)
		Type.OUTPUT_FILLED:
			return Vector2i(4,1)
		Type.COLOR:
			return Vector2i(5,1)
		Type.ERASER:
			return Vector2i(1,4)
		_:
			return Vector2i(-1, -1)

static func texture(tile_type : Type):
	match tile_type:
		Type.BACKGROUND:
			return "res://game/shared/graphics/images/tile_24x24_empty.png"
		Type.INPUT:
			return "res://game/shared/graphics/images/input/tile_24x24_input_opaque.png"
		Type.OUTPUT:
			return "res://game/shared/graphics/images/output/tile_24x24_output_opaque.png"
		_:
			return "res://game/shared/graphics/images/tools/tile_24x24_eraser.png"
