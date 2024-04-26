class Colour:
	var r: float
	var y: float
	var b: float
	var anti: bool

	func _init(r: float, y: float, b: float):
		self.r = r
		self.y = y
		self.b = b

	func color():
		var revr = 1 - self.r
		var revy = 1 - self.y
		var revb = 1 - self.b
		var r = (revr * revy * revb) + (revr * self.y * revb) + (self.r * revy * revb) + (1/2 * (self.r * revy * self.b)) + (self.r * self.y * revb)
		var g = (revr * revy * revb) + (revr * self.y * revb) + (revr * self.y * self.b) + (1/2 * (self.r * self.y * revb))
		var b = (revr * revy * revb) + (revr * revy * self.b) + (1/2 * (self.r * revy * self.b))
		return Color(r, g, b)

class Paint:
	var colour: Colour
	var amount: float

	func _init(colour: Colour, amount: float):
		self.colour = colour
		self.amount = amount

func mix(paints: Array[Paint]):
	var r = 0
	var y = 0
	var b = 0
	for paint in paints:
		r += paint.amount * paint.colour.r
		y += paint.amount * paint.colour.y
		b += paint.amount * paint.colour.b
	r = max(r, 0)
	y = max(y, 0)
	b = max(b, 0)
	var max_paint = max(r, max(y, max(b, 1)))
	r /= max_paint
	y /= max_paint
	b /= max_paint
	return Colour(r, y, b)
