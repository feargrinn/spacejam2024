class_name HoverLayer
extends TileMapLayer

const PIPE_HOVER_ATLAS_COORDS := Vector2i(1, 4)

var tile_interactors: Dictionary[Vector2i, TileInteractor]
var held_pipe: Pipe


func _ready() -> void:
	modulate.a = 0.5


func _process(_delta: float) -> void:
	if held_pipe:
		clear()
		var mouse_position := get_local_mouse_position()
		var mouse_coords := local_to_map(mouse_position)
		set_cell(mouse_coords, 0, held_pipe.get_coordinates(), held_pipe.alternative_id)


func _on_mouse_entered(pos: Vector2i) -> void:
	if !held_pipe:
		set_cell(pos, 0, PIPE_HOVER_ATLAS_COORDS)


func _on_mouse_exited(pos: Vector2i) -> void:
	erase_cell(pos)


func set_held_pipe(pipe: Pipe) -> void:
	held_pipe = pipe


func reset_held_pipe() -> void:
	held_pipe = null
	clear()
	var mouse_position := get_local_mouse_position()
	var mouse_coords := local_to_map(mouse_position)
	if tile_interactors.has(mouse_coords):
		_on_mouse_entered(mouse_coords)


func set_interactor(pos: Vector2i) -> void:
	var interactor := TileInteractor.new()
	add_child(interactor)
	interactor.position = map_to_local(pos)
	tile_interactors[pos] = interactor
	interactor.mouse_entered.connect(_on_mouse_entered.bind(pos))
	interactor.mouse_exited.connect(_on_mouse_exited.bind(pos))
