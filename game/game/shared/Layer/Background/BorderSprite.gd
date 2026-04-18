class_name BorderSprite
extends RefCounted

const BORDER_ROW := 2
const BORDER_DATA_FILEPATHS := [
	"res://data/borders/0001.tres",
	"res://data/borders/00000100.tres",
	"res://data/borders/00000101.tres",
	"res://data/borders/0101.tres",
	"res://data/borders/1001.tres",
	"res://data/borders/1110.tres",
	"res://data/borders/1111.tres",
	"res://data/borders/00010010.tres",
	"res://data/borders/01000100.tres",
	"res://data/borders/01000101.tres",
	"res://data/borders/01010010.tres",
	"res://data/borders/01010101.tres",
	"res://data/borders/10010010.tres",
]

static var tile_set: TileSet = preload("uid://b64fhmdc5bn5")

static var sprites: Array[BorderSprite]

var id: Vector2i;
var alternative: int;
var data: BorderData


static func _static_init() -> void:
	var atlas_source: TileSetAtlasSource = tile_set.get_source(0)
	for fp in BORDER_DATA_FILEPATHS:
		var border_data: BorderData = load(fp)
		for rotation in range(1, border_data.alternatives + 1):
			var atlas_coords := Vector2i(border_data.tileset_id, BORDER_ROW)
			var next_free_id := atlas_source.get_next_alternative_tile_id(atlas_coords)
			var hvt := HVTData.from_rotation_mirror(rotation, rotation > 3)
			atlas_source.create_alternative_tile(atlas_coords)
			var tile_data := atlas_source.get_tile_data(atlas_coords, next_free_id)
			tile_data.flip_h = hvt.flip_h
			tile_data.flip_v = hvt.flip_v
			tile_data.transpose = hvt.transpose
			sprites.append(
				BorderSprite.new(atlas_coords, next_free_id, border_data))


# finds an appropriate border sprite given directions from tile to background tiles
static func with_background_neighbours(neighbours: Array[Vector2i]) -> BorderSprite:
	for sprite in sprites:
		if sprite._fits_neighbours(neighbours):
			return sprite
	return BorderSprite.new(-Vector2i.ONE, 0, null)


func _init(a_id: Vector2i, a_alternative: int, border_data: BorderData) -> void:
	id = a_id
	alternative = a_alternative
	data = border_data


# check whether this sprite works for the provided neighbours
func _fits_neighbours(neighbours: Array[Vector2i]) -> bool:
	var neighbour_requirements := data.get_neighbour_requirements(alternative)
	for direction in neighbour_requirements:
		if neighbour_requirements[direction] != neighbours.has(direction):
			return false
	return true
