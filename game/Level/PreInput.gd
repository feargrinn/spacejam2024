class_name PreInput

const colour_name: String = "colour"
const x_name: String = "x"
const y_name: String = "y"
const rot_name: String = "orientation"

var colour: Colour
var x: int
var y: int
var rot: int

func _init(colour: Colour, x: int, y: int, rot: int):
	self.colour = colour
	self.x = x
	self.y = y
	self.rot = rot

static func from_description(description):
	if not description.has(colour_name):
		return Error.missing_field(colour_name)
	var colour_result = Colour.from_description(description[colour_name])
	if colour_result is Error:
		return colour_result.wrap("failed to parse colour")
	var colour = colour_result
	if not description.has(x_name):
		return Error.missing_field(x_name)
	var x = description[x_name]
	if not description.has(y_name):
		return Error.missing_field(y_name)
	var y = description[y_name]
	if not description.has(rot_name):
		return Error.missing_field(rot_name)
	var rot = description[rot_name]
	return PreInput.new(colour, x, y, rot)

func to_description():
	return {
		colour_name: self.colour.to_description(),
		x_name: self.x,
		y_name: self.y,
		rot_name: self.rot,
	}
