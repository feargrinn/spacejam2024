class_name Colour

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
