class_name PickableTile
extends HBoxContainer

signal tile_picked_up(pipe: Pipe)

const PICKABLE_TILE = preload("uid://bsn66mwfg7trs")

var pipe: Pipe

@onready var tile: TextureRect = $TileButton/Tile


static func create_scene(new_pipe: Pipe) -> PickableTile:
	var new_pickable: PickableTile = PICKABLE_TILE.instantiate()
	new_pickable.pipe = new_pipe
	return new_pickable


func _ready() -> void:
	if pipe:
		tile.texture = pipe.pipe_data.texture


func _on_rotate_pressed(clockwise: bool):
	tile.rotation += (1 if clockwise else -1) * PI/2
	if clockwise:
		pipe.rotate()
	else:
		for i in 3: pipe.rotate()
	Sounds.play("turning")


func _on_tile_button_pressed() -> void:
	tile_picked_up.emit(pipe.my_duplicate())
