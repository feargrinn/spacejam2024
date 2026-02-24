class_name PickableTile
extends HBoxContainer

signal tile_picked_up(tile: TileId)

const PICKABLE_TILE = preload("uid://bsn66mwfg7trs")

var coordinates : Vector2i
var clickable_area : Area2D

var texture: Texture
@onready var tile: TextureRect = $TileButton/Tile


static func create_scene(tile_coordinates: Vector2i, tile_texture: CompressedTexture2D) -> PickableTile:
	var new_pickable: PickableTile = PICKABLE_TILE.instantiate()
	new_pickable.coordinates = tile_coordinates
	new_pickable.texture = tile_texture
	return new_pickable


func _ready() -> void:
	if texture:
		tile.texture = texture


func _on_rotate_pressed(angle_radians: float):
	tile.rotation += angle_radians
	Sounds.play("turning")


func _on_tile_button_pressed() -> void:
	var tile_rotation = int(tile.rotation_degrees/360*4)
	tile_picked_up.emit(TileId.new(coordinates, tile_rotation))
