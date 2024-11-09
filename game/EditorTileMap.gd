extends MarginContainer

var held_tile = null;
var last_placed_input;
var colour_retriever = {}

var background_layer: BackgroundLayer

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

func get_coordinates():
	var mouse_pos_global = get_viewport().get_mouse_position()
	var mouse_pos_local = background_layer.to_local(mouse_pos_global)
	return background_layer.local_to_map(mouse_pos_local)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var tile_pos = get_coordinates()
	$"tile_hover".clear()
	if background_layer.is_background(tile_pos):
		if held_tile:
			$"tile_hover".set_cell(tile_pos, 0, held_tile[0], held_tile[1])


func place():
	var in_range = func(vec):
		var rect_position = Vector2i(-7,-5)
		var rect_size = Vector2i(14,10)
		var rect = Rect2i(rect_position, rect_size)
		return rect.has_point(vec)
	if held_tile:
		var tile_pos = get_coordinates()
		if in_range.call(tile_pos) and held_tile[0] == TileType.coordinates(TileType.Type.BACKGROUND):
			background_layer.set_background(tile_pos)
		elif held_tile[0] == TileType.coordinates(TileType.Type.ERASER):
			if $tile.get_cell_source_id(tile_pos) != -1:
				$tile.erase_cell(tile_pos)
				$tile_colour.erase_cell(tile_pos)
			else:
				background_layer.delete_background(tile_pos)
		elif in_range.call(tile_pos) and held_tile[0] == TileType.coordinates(TileType.Type.INPUT):
			$"tile".set_cell(tile_pos, 0, held_tile[0], held_tile[1])
			$"../../Popup".position = position + $"tile".map_to_local(tile_pos + Vector2i(1,1))
			$"../../Popup".show()
			last_placed_input = [tile_pos, held_tile[1]]
		elif in_range.call(tile_pos) and background_layer.is_background(tile_pos):
			$"tile".set_cell(tile_pos, 0, held_tile[0], held_tile[1])

# TODO: this is temporary until we let the user pick a name
static func random_name():
	var alphabet = "qwertyuiopasdfghjklzxcvbnm"
	var result = ""
	for i in range(16):
		result += alphabet[randi()%len(alphabet)]
	return result
			
func to_level():
	#var name = random_name()
	var level_name = "seven"
	var board_size = background_layer.get_used_rect().size
	var height = board_size.y
	var width = board_size.x
	# TODO: these should be filled from the editor properties,
	# but that's too much for one commit
	var inputs: Array[PreInput] = []
	var outputs: Array[PreOutput] = []
	var tiles: Array[PreTile] = []
	return Level.new(level_name, height, width, inputs, outputs, tiles)

func get_packed_scene_from_tilemap(tilemap_layer, tilemap_position):
	var source_id = tilemap_layer.get_cell_source_id(tilemap_position)
	if source_id > -1:
		var scene_source = tilemap_layer.tile_set.get_source(source_id)
		if scene_source is TileSetScenesCollectionSource:
			var alt_id = tilemap_layer.get_cell_alternative_tile(tilemap_position)
			# The assigned PackedScene.
			return scene_source.get_scene_tile_scene(alt_id)
	return null

func _on_confirm_color_pressed() -> void:
	var alternative_id = Colour.create_coloured_tile(TileType.Type.INPUT_COLOR, last_placed_input[1], $"../../Popup/ColorPicker/ColorRect".color)
	$tile_colour.set_cell(last_placed_input[0], 0, TileType.coordinates(TileType.Type.INPUT_COLOR), alternative_id)
	colour_retriever[last_placed_input] = $"../../Popup/ColorPicker/ColorRect".color_to_preview
	$"../../Popup".hide()
