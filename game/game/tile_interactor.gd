class_name TileInteractor
extends Area2D

const HOVER_ATLAS_COORDS := Vector2i(1, 4)

static var hover_layer

var is_replaceable: bool
var tile_position: Vector2i


func _init(a_tile_position):
	tile_position = a_tile_position


# Called when the node enters the scene tree for the first time.
func _ready():
	var shape = CollisionShape2D.new()
	shape.shape = RectangleShape2D.new()
	shape.shape.size = Vector2(Globals.TILE_SIZE, Globals.TILE_SIZE)
	shape.debug_color = Color.RED
	add_child(shape)
	position = hover_layer.map_to_local(tile_position)
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)


func _on_mouse_entered():
	#start playing tile music
	hover_layer.set_cell(tile_position, 0, HOVER_ATLAS_COORDS)

func _on_mouse_exited():
	#stop playing tile music
	hover_layer.erase_cell(tile_position)
