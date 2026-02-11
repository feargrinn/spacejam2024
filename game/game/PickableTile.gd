extends HBoxContainer
class_name PickableTile

signal tile_picked_up(tile: TileId)

var tile_texture : String
var tile_coordinates : Vector2i
var rotate_left : Button
var rotate_right : Button
var clickable_area : Area2D
var texture : Sprite2D

func _init(a_tile_coordinates : Vector2i, a_tile_texture : String) -> void:
	tile_coordinates = a_tile_coordinates
	tile_texture = a_tile_texture

func _ready():
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	rotate_left = _create_button(" < ")
	add_child(rotate_left)
	add_child(_create_clickable_tile())
	rotate_right = _create_button(" > ")
	add_child(rotate_right)
	rotate_left.connect("pressed", _on_rotate_left_pressed)
	clickable_area.connect("input_event", _on_click.bind(tile_coordinates))
	rotate_right.connect("pressed", _on_rotate_right_pressed)

func _create_button(text : String):
	var button = Button.new()
	button.text = text
	button.size_flags_horizontal = 6 #Control.SIZE_SHRINK_CENTER_EXPAND
	return button

func _create_clickable_tile():
	var control = Control.new()
	control.size_flags_horizontal = 6 #Control.SIZE_SHRINK_CENTER_EXPAND
	control.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	clickable_area = Area2D.new()
	clickable_area.scale = Vector2(3,3)
	var shape = CollisionShape2D.new()
	shape.shape = RectangleShape2D.new()
	clickable_area.add_child(shape)
	texture = Sprite2D.new()
	texture.texture = load(tile_texture)
	clickable_area.add_child(texture)
	control.add_child(clickable_area)
	return control

func _on_rotate_left_pressed():
	texture.rotation -= PI/2
	Sounds.play("turning")


func _on_rotate_right_pressed():
	texture.rotation += PI/2
	Sounds.play("turning")


func _on_click(_viewport: Node, event: InputEvent, _shape_idx: int, tile_type: Vector2i) -> void:
	if event is InputEventMouseButton and event.is_released() and not event.is_echo() and event.button_index == MOUSE_BUTTON_RIGHT:
		_on_rotate_right_pressed()
	elif event is InputEventMouseButton and event.is_released() and not event.is_echo() and event.button_index == MOUSE_BUTTON_LEFT:
		var tile_rotation = int(texture.rotation_degrees/360*4)
		tile_picked_up.emit(TileId.new(tile_type, tile_rotation))
