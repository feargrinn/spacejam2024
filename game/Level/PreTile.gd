class_name PreTile

const TYPE_NAME: String = "type"
const X_NAME: String = "x"
const Y_NAME: String = "y"
const ROT_NAME: String = "orientation"


# coordinates on the tile map
var type: Vector2i
var x: int
var y: int
var rot: int

func _init(a_type: Vector2i, a_x: int, a_y: int, a_rot: int):
	self.type = a_type
	self.x = a_x
	self.y = a_y
	self.rot = a_rot

static func from_description_v1(description):
	if not description.has(TYPE_NAME):
		return Error.missing_field(TYPE_NAME)
	var l_type = str_to_var(description[TYPE_NAME])
	if not description.has(X_NAME):
		return Error.missing_field(X_NAME)
	var l_x = description[X_NAME]
	if not description.has(Y_NAME):
		return Error.missing_field(Y_NAME)
	var l_y = description[Y_NAME]
	if not description.has(ROT_NAME):
		return Error.missing_field(ROT_NAME)
	var l_rot = description[ROT_NAME]
	return PreTile.new(l_type, l_x, l_y, l_rot)

func to_description():
	return {
		TYPE_NAME: var_to_str(self.type),
		X_NAME: self.x,
		Y_NAME: self.y,
		ROT_NAME: self.rot
	}
