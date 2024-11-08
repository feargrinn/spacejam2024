class_name  TileType

enum Type {
	EMPTY,
	BACKGROUND,
	STRAIGHT,
	T,
	L,
	CROSS,
	ANTI,
	INPUT,
	INPUT_COLOR,
	OUTPUT,
	OUTPUT_TARGET_COLOR,
	OUTPUT_FILLED,
	COLOR,
	ERASER,
	MAX_TYPES,
}


static func coordinates(tile_type : Type):
	match tile_type:
		Type.EMPTY:
			return Vector2i(-1,-1)
		Type.BACKGROUND:
			return Vector2i(0,0)
		Type.STRAIGHT:
			return Vector2i(1,0)
		Type.L:
			return Vector2i(2,0)
		Type.T:
			return Vector2i(3,0)
		Type.CROSS:
			return Vector2i(4,0)
		Type.ANTI:
			return Vector2i(5,0)
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
