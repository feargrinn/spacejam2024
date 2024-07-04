class_name Level

const official_level_dir: String = "res://levels"
const user_level_dir: String = "user://levels"

const title_name: String = "name"
const height_name: String = "height"
const width_name: String = "width"
const inputs_name: String = "inputs"
const outputs_name: String = "outputs"
const tiles_name: String = "tiles"

var name: String
var height: int
var width: int
var inputs: Array[PreInput]
var outputs: Array[PreOutput]
var tiles: Array[PreTile]

static func load_default():
	return load_from_dir(official_level_dir)

static func load_user():
	return load_from_dir(user_level_dir)

static func load_from_dir(dir_name: String):
	var dir = DirAccess.open(dir_name)
	if not dir:
		return Error.new("failed to open directory %s" % dir_name)
	var levels: Array[Level] = []
	for filename in dir.get_files():
		var level_result = load_from_file("%s/%s" % [dir_name, filename])
		if level_result is Error:
			return level_result.wrap("failed to load level from file %s" % filename)
		levels.append(level_result)
	return levels

static func load_from_file(filename: String):
	if not FileAccess.file_exists(filename):
		return Error.no_file(filename)
	var level_file = FileAccess.open(filename, FileAccess.READ)
	var loaded_json = level_file.get_as_text()
	var json = JSON.new()
	if not json.parse(loaded_json) == OK:
		return Error.json_parse(loaded_json, json)
	var loaded_data = json.get_data()
	if not loaded_data.has(title_name):
		return Error.missing_field(title_name)
	var name = loaded_data[title_name]
	if not loaded_data.has(height_name):
		return Error.missing_field(height_name)
	var height = loaded_data[height_name]
	if not loaded_data.has(width_name):
		return Error.missing_field(width_name)
	var width = loaded_data[width_name]
	if not loaded_data.has(inputs_name):
		return Error.missing_field(inputs_name)
	var inputs: Array[PreInput] = []
	for input_description in loaded_data[inputs_name]:
		var input_tile = PreInput.from_description(input_description)
		if input_tile is Error:
			return input_tile.wrap("failed to load input tile")
		inputs.append(input_tile)
	if not loaded_data.has(outputs_name):
		return Error.missing_field(outputs_name)
	var outputs: Array[PreOutput] = []
	for output_description in loaded_data[outputs_name]:
		var output_tile = PreOutput.from_description(output_description, inputs)
		if output_tile is Error:
			return output_tile.wrap("failed to load output tile")
		outputs.append(output_tile)
	if not loaded_data.has(tiles_name):
		return Error.missing_field(tiles_name)
	var tiles: Array[PreTile] = []
	for tile_description in loaded_data[tiles_name]:
		var tile = PreTile.from_description(tile_description)
		if tile is Error:
			return tile.wrap("failed to load tile")
		tiles.append(tile)
	return Level.new(name, height, width, inputs, outputs, tiles)

func _init(name: String, height: int, width: int, inputs: Array[PreInput], outputs: Array[PreOutput], tiles: Array[PreTile]):
	self.name = name
	self.height = height
	self.width = width
	self.inputs = inputs
	self.outputs = outputs
	self.tiles = tiles
