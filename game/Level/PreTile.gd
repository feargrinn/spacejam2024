class_name PreTile

const type_name: String = "type"
const x_name: String = "x"
const y_name: String = "y"
const rot_name: String = "orientation"


var type: TileType.Type
var x: int
var y: int
var rot: int

func _init(a_type: TileType.Type, a_x: int, a_y: int, a_rot: int):
	self.type = a_type
	self.x = a_x
	self.y = a_y
	self.rot = a_rot

static func from_description(description):
	if not description.has(type_name):
		return Error.missing_field(type_name)
	if description[type_name] >= TileType.Type.MAX_TYPES:
		return Error.new("unknown tile type")
	var l_type = description[type_name]
	if not description.has(x_name):
		return Error.missing_field(x_name)
	var l_x = description[x_name]
	if not description.has(y_name):
		return Error.missing_field(y_name)
	var l_y = description[y_name]
	if not description.has(rot_name):
		return Error.missing_field(rot_name)
	var l_rot = description[rot_name]
	return PreTile.new(l_type, l_x, l_y, l_rot)

func to_description():
	return {
		type_name: self.type,
		x_name: self.x,
		y_name: self.y,
		rot_name: self.rot
	}
