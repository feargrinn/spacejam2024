extends MarginContainer

var held_tile = null;
var last_placed_input;

var background_layer: BackgroundLayer
var tile_layer: TileLayer
var tile_colour_layer: ColourLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.background_layer = BackgroundLayer.new({
		Vector2i(1,1): true,
		Vector2i(1,2): true,
		Vector2i(1,3): true,
		Vector2i(1,4): true,
		Vector2i(2,1): true,
		Vector2i(2,2): true,
		Vector2i(2,3): true,
		Vector2i(2,4): true,
	})
	self.add_child(self.background_layer)
	self.tile_layer = TileLayer.new()
	self.add_child(self.tile_layer)
	self.tile_colour_layer = ColourLayer.new()
	self.add_child(self.tile_colour_layer)
	TileInteractor.hover_layer = $tile_hover
	TileInteractor.tile_layer = self.tile_layer
	self.move_child(self.background_layer, 0)
	self.move_child(self.tile_colour_layer, 1)
	self.move_child(self.tile_layer, 2)

func get_coordinates():
	var mouse_pos_global = get_viewport().get_mouse_position()
	var mouse_pos_local = background_layer.to_local(mouse_pos_global)
	return background_layer.local_to_map(mouse_pos_local)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var tile_pos = get_coordinates()
	$"tile_hover".clear()
	if held_tile:
		if background_layer.is_ok_for_input_or_output(tile_pos) and TileType.is_input_or_output(held_tile.id):
			var output_offset = 2 if held_tile.id == TileType.coordinates(TileType.Type.OUTPUT) else 0
			while !background_layer.is_ok_for_input_or_output(tile_pos).has((held_tile.alternative + output_offset)%4):
				held_tile.rotate()
			$"tile_hover".set_cell(tile_pos, 0, held_tile.id, held_tile.alternative)
		elif background_layer.is_background(tile_pos) and TileType.is_pipe_tile(held_tile.id):
			$"tile_hover".set_cell(tile_pos, 0, held_tile.id, held_tile.alternative)
		elif not background_layer.is_background(tile_pos) and held_tile.id == TileType.coordinates(TileType.Type.BACKGROUND):
			$"tile_hover".set_cell(tile_pos, 0, held_tile.id, held_tile.alternative)

func place():
	var in_range = func(vec):
		var rect_position = Vector2i(-7,-5)
		var rect_size = Vector2i(14,10)
		var rect = Rect2i(rect_position, rect_size)
		return rect.has_point(vec)
	if held_tile:
		var tile_pos = get_coordinates()
		if in_range.call(tile_pos) and held_tile.id == TileType.coordinates(TileType.Type.BACKGROUND):
			background_layer.set_background(tile_pos)
		elif held_tile.id == TileType.coordinates(TileType.Type.ERASER):
			if !tile_layer.empty_at(tile_pos):
				tile_layer.remove_tile(tile_pos)
				tile_colour_layer.erase_cell(tile_pos)
			else:
				background_layer.delete_background(tile_pos)
		elif in_range.call(tile_pos) and held_tile.id == TileType.coordinates(TileType.Type.INPUT):
			tile_layer.place_tile(tile_pos, held_tile)
			$"../../Popup".position = position + tile_layer.map_to_local(tile_pos + Vector2i(1,1))
			$"../../Popup".show()
			last_placed_input = [tile_pos, held_tile.alternative]
		elif in_range.call(tile_pos) and held_tile.id == TileType.coordinates(TileType.Type.OUTPUT):
			tile_layer.place_tile(tile_pos, held_tile)
		elif in_range.call(tile_pos) and background_layer.is_background(tile_pos):
			tile_layer.place_tile(tile_pos, held_tile)

func get_pretiles_from_tilemap_layer() -> Array[PreTile]:
	var pretiles: Array[PreTile] = []
	var used_cells = tile_layer.get_used_cells()
	for cell_coordinates in used_cells:
		if tile_layer.is_input(cell_coordinates) or tile_layer.is_output(cell_coordinates):
			continue
		var tile_type = tile_layer.get_cell_atlas_coords(cell_coordinates)
		pretiles.append(PreTile.new(tile_type,	cell_coordinates.x, cell_coordinates.y, tile_layer.get_cell_alternative_tile(cell_coordinates)))
	return pretiles

func get_preinputs_from_layers() -> Array[PreInput]:
	var preinputs: Array[PreInput] = []
	var used_cells = tile_layer.get_used_cells()
	for cell_coordinates in used_cells:
		if tile_layer.is_input(cell_coordinates):
			preinputs.append(PreInput.new(tile_colour_layer.get_tile_colour(cell_coordinates), cell_coordinates.x, cell_coordinates.y, tile_layer.get_cell_alternative_tile(cell_coordinates)))
	return preinputs

func to_level() -> Level:
	var level_name = $"../LevelName".get_text()
	var background = self.background_layer.background_dict()
	# TODO: these should be filled from the editor properties,
	# but that's too much for one commit
	var inputs = get_preinputs_from_layers()
	var outputs: Array[PreOutput] = []
	var tiles = get_pretiles_from_tilemap_layer()
	return Level.new(level_name, background, inputs, outputs, tiles)

func get_packed_scene_from_tilemap(tilemap_layer, tilemap_position):
	var source_id = tilemap_layer.get_cell_source_id(tilemap_position)
	if source_id > -1:
		var scene_source = tilemap_layer.tile_set.get_source(source_id)
		if scene_source is TileSetScenesCollectionSource:
			var alt_id = tilemap_layer.get_cell_alternative_tile(tilemap_position)
			# The assigned PackedScene.
			return scene_source.get_scene_tile_scene(alt_id)
	return null


func _on_colour_picked(colour: Colour) -> void:
	var input = PreInput.new(colour, last_placed_input[0].x, last_placed_input[0].y, last_placed_input[1])
	tile_colour_layer.set_tile_colour(last_placed_input[0], colour, input)
	$"../../Popup".hide()
