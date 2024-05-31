class_name PreTile

const type_name: String = "type"
const x_name: String = "x"
const y_name: String = "y"
const rot_name: String = "orientation"

enum TileType {
	STRAIGHT,
	T,
	L,
	CROSS,
	ANTI,
	MAX_TYPES,
}

var type: TileType
var x: int
var y: int
var rot: int

func _init(type: TileType, x: int, y: int, rot: int):
	self.type = type
	self.x = x
	self.y = y
	self.rot = rot

static func from_description(description):
	if not description.has(type_name):
		return Error.missing_field(type_name)
	if description[type_name] >= TileType.MAX_TYPES:
		return Error.new("unknown tile type")
	var type = description[type_name]
	if not description.has(x_name):
		return Error.missing_field(x_name)
	var x = description[x_name]
	if not description.has(y_name):
		return Error.missing_field(y_name)
	var y = description[y_name]
	if not description.has(rot_name):
		return Error.missing_field(rot_name)
	var rot = description[rot_name]
	return PreTile.new(type, x, y, rot)
