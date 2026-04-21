class_name BorderSprite
extends RefCounted
## This class is responsible for creating alternative tiles according to 
## BorderData specifications.
## And for finding appropriate alternatives to use given requirements.

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

var data: BorderData
var alternative: int
var rotation: int


static func _static_init() -> void:
	var atlas_source: TileSetAtlasSource = tile_set.get_source(0)
	for fp in BORDER_DATA_FILEPATHS:
		var border_data: BorderData = load(fp)
		sprites.append(BorderSprite.new(border_data))
		var alternatives := _create_alternatives(atlas_source, border_data)
		sprites.append_array(alternatives)


static func _create_alternatives(
		atlas_source: TileSetAtlasSource,
		border_data: BorderData) -> Array[BorderSprite]:
	
	var alternatives: Array[BorderSprite]
	
	for rot in range(1, border_data.alternatives + 1):
		var alt_tile := _create_alternative_tile(
			atlas_source, border_data,
			rot, false)
		
		alternatives.append(alt_tile)
		
		if border_data.requires_mirror:
			alt_tile = _create_alternative_tile(
					atlas_source, border_data,
					rot, false)
			
			alternatives.append(alt_tile)
	
	return alternatives


static func _create_alternative_tile(
		atlas_source: TileSetAtlasSource,
		border_data: BorderData,
		alt_rotation: int,
		mirror: bool) -> BorderSprite:
	
	var atlas_coords := border_data.tileset_coords
	var alt_id := atlas_source.create_alternative_tile(atlas_coords)
	var hvt := HVTData.from_rotation_mirror(alt_rotation, mirror)
	
	var tile_data := atlas_source.get_tile_data(atlas_coords, alt_id)
	tile_data.flip_h = hvt.flip_h
	tile_data.flip_v = hvt.flip_v
	tile_data.transpose = hvt.transpose
	return BorderSprite.new(border_data, alt_id, alt_rotation)


# finds an appropriate border sprite given directions from tile to background tiles
static func with_background_neighbours(neighbours: Array[Vector2i]) -> BorderSprite:
	for sprite in sprites:
		if sprite._fits_neighbours(neighbours):
			return sprite
	return BorderSprite.new(BorderData.empty())


func _init(border_data: BorderData, a_alternative: int = 0, rot: int = 0) -> void:
	alternative = a_alternative
	data = border_data
	rotation = rot


func _to_string() -> String:
	return str(data.get_neighbour_requirements(alternative))


# check whether this sprite works for the provided neighbours
func _fits_neighbours(neighbours: Array[Vector2i]) -> bool:
	var neighbour_requirements := data.get_neighbour_requirements(rotation)
	for direction in neighbour_requirements:
		if neighbour_requirements[direction] != neighbours.has(direction):
			return false
	return true


func get_tileset_coords() -> Vector2i:
	return data.tileset_coords
