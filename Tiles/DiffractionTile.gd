extends Tile

class_name DiffractionTile

var colors: Array[Colour]

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_color_for_side(color: Colour, link: int):
	colors[link] = color
	colors[(link + 1) % 4] = Colour.new(color.r, 0, 0)
	colors[(link + 2) % 4] = Colour.new(0, color.y, 0)
	colors[(link + 3) % 4] = Colour.new(0, 0, color.b)

func get_paint_from_side(link: int) -> Paint:
	return Paint.new(colors[link], pipe_size)
