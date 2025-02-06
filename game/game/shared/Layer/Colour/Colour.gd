class_name Colour

const r_name: String = "red"
const y_name: String = "yellow"
const b_name: String = "blue"

var r: float
var y: float
var b: float

static var colour_coords = TileType.coordinates(TileType.Type.COLOR)
var colour_id

func _init(a_r: float, a_y: float, a_b: float):
	self.r = a_r
	self.y = a_y
	self.b = a_b
	colour_id = create_tile_colour(self)

static func from_description(description):
	if not description.has(r_name):
		return Error.missing_field(r_name)
	var l_r = description[r_name]
	if not description.has(y_name):
		return Error.missing_field(y_name)
	var l_y = description[y_name]
	if not description.has(b_name):
		return Error.missing_field(b_name)
	var l_b = description[b_name]
	return Colour.new(l_r, l_y, l_b)

static func create_input_or_output_colour(tile_type, tile_rotation, new_colour):
	var coordinates_in_source = TileType.coordinates(tile_type)
	var atlas_source = Globals.TILE_SET.get_source(0)
	var coloured_alternative_id = atlas_source.create_alternative_tile(coordinates_in_source)
	var tile_data = atlas_source.get_tile_data(coordinates_in_source, tile_rotation)
	var new_tile_data = atlas_source.get_tile_data(coordinates_in_source, coloured_alternative_id)
	new_tile_data.flip_h = tile_data.flip_h
	new_tile_data.flip_v = tile_data.flip_v
	new_tile_data.transpose = tile_data.transpose
	new_tile_data.modulate = new_colour
	return coloured_alternative_id

static func create_tile_colour(new_colour):
	var atlas_source = Globals.TILE_SET.get_source(0)
	var coloured_alternative_id = atlas_source.create_alternative_tile(colour_coords)
	var new_tile_data = atlas_source.get_tile_data(colour_coords, coloured_alternative_id)
	new_tile_data.modulate = new_colour.color()
	return coloured_alternative_id

func to_description():
	return {
		r_name: self.r,
		y_name: self.y,
		b_name: self.b
	}

# RYB to RGB conversion
func color():
	var revr = 1 - self.r
	var revy = 1 - self.y
	var revb = 1 - self.b
	var l_r = (revr * revy * revb) + (revr * self.y * revb) + (self.r * revy * revb) + (0.5 * (self.r * revy * self.b)) + (self.r * self.y * revb)
	var l_g = (revr * revy * revb) + (revr * self.y * revb) + (revr * self.y * self.b) + (0.5 * (self.r * self.y * revb))
	var l_b = (revr * revy * revb) + (revr * revy * self.b) + (0.5 * (self.r * revy * self.b))
	return Color(l_r, l_g, l_b)

func whiteness() -> float:
	return (1 - self.r)*(1 - self.y)*(1 - self.b)

func is_equal(other: Colour) -> bool:
	return r == other.r and y == other.y and b == other.b

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
