class_name PreInput

const colour_name: String = "colour"
const x_name: String = "x"
const y_name: String = "y"
const rot_name: String = "orientation"

var colour: Colour
var x: int
var y: int
var rot: int

func _init(a_colour: Colour, a_x: int, a_y: int, a_rot: int):
	self.colour = a_colour
	self.x = a_x
	self.y = a_y
	self.rot = a_rot

static func from_description(description):
	if not description.has(colour_name):
		return Error.missing_field(colour_name)
	var colour_result = Colour.from_description(description[colour_name])
	if colour_result is Error:
		return colour_result.wrap("failed to parse colour")
	var l_colour = colour_result
	if not description.has(x_name):
		return Error.missing_field(x_name)
	var l_x = description[x_name]
	if not description.has(y_name):
		return Error.missing_field(y_name)
	var l_y = description[y_name]
	if not description.has(rot_name):
		return Error.missing_field(rot_name)
	var l_rot = description[rot_name]
	return PreInput.new(l_colour, l_x, l_y, l_rot)

func to_description():
	return {
		colour_name: self.colour.to_description(),
		x_name: self.x,
		y_name: self.y,
		rot_name: self.rot,
	}
