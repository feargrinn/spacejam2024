class_name PreOutput

const colour_name: String = "colour"
const x_name: String = "x"
const y_name: String = "y"
const rot_name: String = "orientation"
const input_index_name: String = "input"
const mix_name: String = "mix"
const amount_name: String = "amount"

var colour_description
var colour: Colour
var x: int
var y: int
var rot: int

func _init(a_colour_description, a_x: int, a_y: int, a_rot: int):
	self.colour_description = a_colour_description
	self.x = a_x
	self.y = a_y
	self.rot = a_rot

# doing this separately, because apparently you cannot return errors from constructors :<
func init_colour(inputs):
	var colour_result = load_colour(self.colour_description, inputs)
	if colour_result is Error:
		return colour_result.wrap("failed to load colour")
	self.colour = colour_result

static func load_paint(description, inputs):
	if not description.has(colour_name):
		return Error.missing_field(colour_name)
	var l_colour = load_colour(description[colour_name], inputs)
	if l_colour is Error:
		return l_colour.wrap("failed to load colour")
	if not description.has(amount_name):
		return Error.missing_field(amount_name)
	var amount = description[amount_name]
	return Paint.new(l_colour, amount)

static func load_mix(description, inputs):
	var paints: Array[Paint] = []
	for paint_description in description:
		var paint_result = load_paint(paint_description, inputs)
		if paint_result is Error:
			return paint_result.wrap("failed to load paint")
		paints.append(paint_result)
	return Paint.mix(paints)

static func load_colour(description, inputs):
	if description.has(input_index_name):
		var input_index = description[input_index_name]
		if inputs.size() <= input_index:
			return Error.new("no input number %d" % input_index)
		return inputs[input_index].colour
	if description.has(mix_name):
		return load_mix(description[mix_name], inputs)
	return Error.new("invalid colour description")

static func from_description(description, inputs):
	if not description.has(colour_name):
		return Error.missing_field(colour_name)
	var l_colour_description = description[colour_name]
	if not description.has(x_name):
		return Error.missing_field(x_name)
	var l_x = description[x_name]
	if not description.has(y_name):
		return Error.missing_field(y_name)
	var l_y = description[y_name]
	if not description.has(rot_name):
		return Error.missing_field(rot_name)
	var l_rot = description[rot_name]
	var result = PreOutput.new(l_colour_description, l_x, l_y, l_rot)
	var init_colour_result = result.init_colour(inputs)
	if init_colour_result is Error:
		return init_colour_result
	return result

func to_description():
	return {
		colour_name: self.colour_description,
		x_name: self.x,
		y_name: self.y,
		rot_name: self.rot
	}
