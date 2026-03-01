class_name HoverLayer
extends TileMapLayer

const TILE_HOVER_ATLAS_COORDS := Vector2i(1, 4)

var tile_interactors: Dictionary[Vector2i, TileInteractor]


func _ready() -> void:
	modulate.a = 0.5


func set_interactor(pos: Vector2i) -> void:
	var interactor := TileInteractor.new()
	add_child(interactor)
	interactor.position = map_to_local(pos)
	tile_interactors[pos] = interactor
	interactor.mouse_entered.connect(_on_mouse_entered.bind(pos))
	interactor.mouse_exited.connect(_on_mouse_exited.bind(pos))


func _on_mouse_entered(pos: Vector2i) -> void:
	set_cell(pos, 0, TILE_HOVER_ATLAS_COORDS)


func _on_mouse_exited(pos: Vector2i) -> void:
	erase_cell(pos)
