class_name Paint

var colour: Colour
var amount: float

func _init(a_colour: Colour, a_amount: float):
	self.colour = a_colour
	self.amount = a_amount

static func negligible(f: float) -> bool:
	# so close that it shouldn't impact anything visible (and thus colour comparison), but way above the float accuracy
	var error_margin = 0.0001
	return abs(f) < error_margin

static func normalized_colour(r: float, y: float, b: float, whiteness: float) -> Colour:
	var max_colour = max(r, max(y, b))
	# all the colours are 0, we default to white paint; this is where we potentially identify "no pain" with "white paint"
	if negligible(max_colour):
		return Colour.new(0,0,0)
	var upper_limit = 1./max_colour
	# with no whiteness return a colour with at least one 1; not strictly necessary, but avoids the binsearch having the other end
	if negligible(whiteness):
		return Colour.new(r*upper_limit, y*upper_limit, b*upper_limit)
	var lower_limit = 0.
	var attempt = 0
	# just a limit to avoid looping forever
	while attempt < 100:
		attempt += 1
		var beta = (upper_limit + lower_limit)/2
		var l_colour = Colour.new(r*beta, y*beta, b*beta)
		var inaccuracy = whiteness*beta - l_colour.whiteness()
		if attempt % 10 == 0:
			print("attempt ", attempt, " with inaccuracy ", inaccuracy)
		# the proportion is close enough
		if negligible(inaccuracy):
			return l_colour
		# just binsearch
		if inaccuracy > 0:
			upper_limit = beta
		else:
			lower_limit = beta
	print("failed to converge after 100 steps, upper limit ", upper_limit, " lower limit ", lower_limit)
	return Colour.new(0, 0, 0)

static func mix(paints: Array[Paint]) -> Colour:
	var r = 0
	var y = 0
	var b = 0
	var whiteness = 0
	# add all the paints to get the proportions
	for paint in paints:
		r += paint.amount * paint.colour.r
		y += paint.amount * paint.colour.y
		b += paint.amount * paint.colour.b
		whiteness += paint.amount * paint.colour.whiteness()
	# any negative paints at this point are simply missing
	r = max(r, 0)
	y = max(y, 0)
	b = max(b, 0)
	whiteness = max(whiteness, 0)
	return normalized_colour(r, y, b, whiteness)
