class_name Paint

const colour_script = preload("res://Colour.gd")

var colour: Colour
var amount: float

func _init(colour: Colour, amount: float):
	self.colour = colour
	self.amount = amount

static func mix(paints: Array[Paint]) -> Colour:
	var r = 0
	var y = 0
	var b = 0
	#var max_paint = 0
	for paint in paints:
		r += paint.amount * paint.colour.r
		y += paint.amount * paint.colour.y
		b += paint.amount * paint.colour.b
		#max_paint += paint.amount
	r = max(r, 0)
	y = max(y, 0)
	b = max(b, 0)
	var max_paint = max(r, max(y, max(b, 1)))
	#max_paint = max(max_paint, 1)
	r /= max_paint
	y /= max_paint
	b /= max_paint
	
	return colour_script.new(r, y, b)
