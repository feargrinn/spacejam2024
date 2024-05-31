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

func __ready():
	pass

func isEqual(colour: Colour) -> bool:
	return r == colour.r && y == colour.y && b == colour.b

func color():
	var revr = 1 - self.r
	var revy = 1 - self.y
	var revb = 1 - self.b
	var r = (revr * revy * revb) + (revr * self.y * revb) + (self.r * revy * revb) + (0.5 * (self.r * revy * self.b)) + (self.r * self.y * revb)
	var g = (revr * revy * revb) + (revr * self.y * revb) + (revr * self.y * self.b) + (0.5 * (self.r * self.y * revb))
	var b = (revr * revy * revb) + (revr * revy * self.b) + (0.5 * (self.r * revy * self.b))
	return Color(r, g, b)
