extends Sprite2D

class_name Colour

const r_name: String = "red"
const y_name: String = "yellow"
const b_name: String = "blue"

var r: float
var y: float
var b: float

func _init(r: float, y: float, b: float):
	self.r = r
	self.y = y
	self.b = b
	texture = preload("res://images/paint_texture.tres")
	modulate = color()
	z_index = -1

static func from_description(description):
	if not description.has(r_name):
		return Error.missing_field(r_name)
	var r = description[r_name]
	if not description.has(y_name):
		return Error.missing_field(y_name)
	var y = description[y_name]
	if not description.has(b_name):
		return Error.missing_field(b_name)
	var b = description[b_name]
	return Colour.new(r, y, b)

func to_description():
	return {
		r_name: self.r,
		y_name: self.y,
		b_name: self.b
	}

func __ready():
	pass

# RYB to RGB conversion
func color():
	var revr = 1 - self.r
	var revy = 1 - self.y
	var revb = 1 - self.b
	var r = (revr * revy * revb) + (revr * self.y * revb) + (self.r * revy * revb) + (0.5 * (self.r * revy * self.b)) + (self.r * self.y * revb)
	var g = (revr * revy * revb) + (revr * self.y * revb) + (revr * self.y * self.b) + (0.5 * (self.r * self.y * revb))
	var b = (revr * revy * revb) + (revr * revy * self.b) + (0.5 * (self.r * revy * self.b))
	return Color(r, g, b)

func whiteness() -> float:
	return (1 - self.r)*(1 - self.y)*(1 - self.b)

func is_similar(target_colour: Colour) -> bool:
	var error_margin = 0.2
	
	# converted RGB variant
	var color1 = color()
	var color2 = target_colour.color()
	var r1 = color1.r
	var g1 = color1.g
	var b1 = color1.b
	var r2 = color2.r
	var g2 = color2.g
	var b2 = color2.b
	
	# same for both
	# redmean approach for colour components 0-1 in RGB colour space
	var rm = 0.5 * (r1 + r2)
	var difference = sqrt((2 + rm) * pow((r1 - r2), 2) +
	4 * pow((g1 - g2), 2) + (2 + (1 - rm)) * pow((b1 - b2), 2))
	print("colour dif = ", difference)
	return difference < error_margin
