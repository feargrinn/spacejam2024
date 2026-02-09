class_name AnimatedTile
extends AnimatedSprite2D

const ANIMATED_TILE = preload("uid://7jeubcg4hei2")


static func custom_new(parent_tile_layer: TileLayer, animation_name: String,
		tile_coords: Vector2i) -> AnimatedTile:
	var tile: AnimatedTile = ANIMATED_TILE.instantiate()
	parent_tile_layer.add_child(tile)
	tile.global_position = parent_tile_layer.to_global(parent_tile_layer.map_to_local(tile_coords))
	tile.global_rotation = parent_tile_layer.get_cell_alternative_tile(tile_coords) * PI/2
	tile.play(animation_name)
	tile.animation_finished.connect(tile.queue_free)
	return tile
