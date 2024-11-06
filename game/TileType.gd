class_name TileType

static func EMPTY():
	return Vector2i(-1,-1)

static func BACKGROUND():
	return Vector2i(0,0)

static func STRAIGHT():
	return Vector2i(1,0)

static func T():
	return Vector2i(2,0)

static func L():
	return Vector2i(3,0)

static func CROSS():
	return Vector2i(4,0)

static func ANTI():
	return Vector2i(5,0)

static func INPUT():
	return Vector2i(0,1)

static func INPUT_COLOR():
	return Vector2i(2,1)

static func OUTPUT():
	return Vector2i(1,1)

static func OUTPUT_COLOR():
	return Vector2i(3,1)

static func OUTPUT_FILLED():
	return Vector2i(4,1)

static func ERASER():
	return Vector2i(1,4)
