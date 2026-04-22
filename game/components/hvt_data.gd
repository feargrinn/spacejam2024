class_name HVTData
extends RefCounted

enum Rotation{
	BASE,
	QUARTER_CLOCKWISE,
	HALF,
	QUARTER_COUNTERCLOCKWISE
}

var flip_h: bool
var flip_v: bool
var transpose: bool


static func from_rotation_mirror(alternative_rotation: Rotation, mirror_h: bool = false) -> HVTData:
	var result := HVTData.new()
	result.transpose = alternative_rotation in [1, 3]
	result.flip_h = alternative_rotation in [1, 2]
	result.flip_h = !result.flip_h if mirror_h else result.flip_h
	result.flip_v = alternative_rotation in [2, 3]
	return result
