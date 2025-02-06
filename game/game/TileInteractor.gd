extends Area2D

class_name TileInteractor

var is_replaceable: bool

var tile_position: Vector2i

static var tile_layer
static var hover_layer

func _init(a_tile_position):
	tile_position = a_tile_position


# Called when the node enters the scene tree for the first time.
func _ready():
	var shape = CollisionShape2D.new()
	shape.shape = RectangleShape2D.new()
	shape.shape.size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE)
	shape.debug_color = Color.RED
	add_child(shape)
	position = tile_layer.map_to_local(tile_position)
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)


func _on_mouse_entered():
	#start playing tile music
	hover_layer.set_cell(tile_position, 0, TileType.coordinates(TileType.Type.ERASER))

func _on_mouse_exited():
	#stop playing tile music
	hover_layer.erase_cell(tile_position)
