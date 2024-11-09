class_name BorderSprite

const BORDER_SPRITE_NUM = 13

var id;
var alternative;

func _init(id, alternative):
	self.id = id
	self.alternative = alternative

func get_sprite_pointer():
	# apparently this is the format for the sprite pointer
	return Vector2i(self.id, 2)

func get_alternative():
	return self.alternative

static func alternatives_for(id):
		return range(Globals.TILE_SET.get_source(0).get_alternative_tiles_count(Vector2i(id,2)))

func is_valid():
	return Globals.TILE_SET.get_source(0).has_alternative_tile(self.get_sprite_pointer(), self.alternative)

# gets a description of directions in which the given sprite expects background tiles
func background_neighbours():
	if !self.is_valid():
		return Error.new("we should only ask about background neighbours of valid sprites")
	var tile_data = Globals.TILE_SET.get_source(0).get_tile_data(self.get_sprite_pointer(), self.alternative)
	return tile_data.get_custom_data("required_neighbours")

# check whether this sprite works for the provided neighbours
func fits_neighbours(neighbours):
	var neighbour_requirements = self.background_neighbours()
	for direction in neighbour_requirements:
		if neighbour_requirements[direction] != neighbours.has(direction):
			return false
	return true

# finds an appropriate border sprite given directions from tile to background tiles
static func with_background_neighbours(neighbours):
	for id in range(BORDER_SPRITE_NUM):
		for alternative in alternatives_for(id):
			var candidate_sprite = BorderSprite.new(id, alternative)
			if candidate_sprite.fits_neighbours(neighbours):
				return candidate_sprite
	return Error.new("no border sprite needed")

