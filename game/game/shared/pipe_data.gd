@tool
class_name PipeData
extends Resource

enum Type{
	STRAIGHT,
	T,
	L,
	CROSS,
	ANTI,
}

static var pipes: Dictionary[Type, PipeData] = {
	Type.STRAIGHT: load("uid://dv1gcsvm1jfd6"),
	Type.T: load("uid://db20ja7biruiv"),
	Type.L: load("uid://djbrq7ccp61uy"),
	Type.CROSS: load("uid://dax163sm858dl"),
	Type.ANTI: load("uid://ccd412jpyloh6"),
}


@export var type: Type
@export var texture: Texture
@export var tileset_coordinates: Vector2i
@export var connections: Dictionary[Vector2i, bool]


func _init() -> void:
	for i in 3:
		for j in 3:
			connections[Vector2i(i - 1, j - 1)] = !(abs(i - 1) == abs(j - 1))


func get_connections() -> Array[Vector2i]:
	var existing := connections.keys().filter(func(key): return connections[key])
	return existing
