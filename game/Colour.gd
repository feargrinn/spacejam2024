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

# nie jest ok bo porownujesz floaty, zrobic inty (rgb przyjmuje rgp inty jako string???)
func isEqual(colour: Colour) -> bool:
	return r == colour.r && y == colour.y && b == colour.b

# RYB to RGB conversion
func color():
	var revr = 1 - self.r
	var revy = 1 - self.y
	var revb = 1 - self.b
	var r = (revr * revy * revb) + (revr * self.y * revb) + (self.r * revy * revb) + (0.5 * (self.r * revy * self.b)) + (self.r * self.y * revb)
	var g = (revr * revy * revb) + (revr * self.y * revb) + (revr * self.y * self.b) + (0.5 * (self.r * self.y * revb))
	var b = (revr * revy * revb) + (revr * revy * self.b) + (0.5 * (self.r * revy * self.b))
	return Color(r, g, b)

func color_diffference(target_colour: Colour) -> bool:
	var error_margin = 50
	# add a step converting ryb to rgb??? or h, adjust stuff for ryb somehow...
	
	# crude RYB variant
	#var r1 := int(target_colour.r * 255) # needs rounding?
	#var g1 := int(target_colour.y * 255)
	#var b1 := int(target_colour.b * 255)
	#var r2 := int(r * 255)
	#var g2 := int(y * 255)
	#var b2 := int(b * 255)
	
	# converted RGB variant
	var color1 = color()
	var color2 = target_colour.color()
	var r1 := int(color1.r * 255) # needs rounding?
	var g1 := int(color1.g * 255)
	var b1 := int(color1.b * 255)
	var r2 := int(color2.r * 255)
	var g2 := int(color2.g * 255)
	var b2 := int(color2.b * 255)
	
	# same for both
	# redmean approach for colour components 0-255 in RGB colour space
	var rm := float(0.5 * (r1 + r2)) # rounding again?
	var difference := float(sqrt((2 + rm / 256) * pow((r1 - r2), 2) +
	4 * pow((g1 - g2), 2) + (2 + (255 - rm) / 256) * pow((b1 - b2), 2)))
	#print("colour dif = ", difference)
	return difference < error_margin
