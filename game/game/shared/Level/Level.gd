class_name Level

const OFFICIAL_LEVEL_DIR: String = "res://data/levels/"
const USER_LEVEL_DIR: String = "user://levels"

const VERSION_NAME: String = "version"
const TITLE_NAME: String = "name"
const BACKGROUND_NAME: String = "background"
const INPUTS_NAME: String = "inputs"
const OUTPUTS_NAME: String = "outputs"
const TILES_NAME: String = "tiles"

# legacy
const HEIGHT_NAME: String = "height"
const WIDTH_NAME: String = "width"

var name: String
var background: Dictionary
var inputs: Array[PreInput]
var outputs: Array[PreOutput]
var tiles: Array[PreTile]

func _init(a_name: String, new_background: Dictionary[Vector2i, bool], a_inputs: Array[PreInput], a_outputs: Array[PreOutput], a_tiles: Array[PreTile]):
	self.name = a_name
	self.background = new_background
	self.inputs = a_inputs
	self.outputs = a_outputs
	self.tiles = a_tiles

static func load_default():
	return load_from_dir(OFFICIAL_LEVEL_DIR)

static func load_user():
	return load_from_dir(USER_LEVEL_DIR)

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
	if not loaded_data.has(VERSION_NAME):
		return Error.missing_field(VERSION_NAME)
	var format_version: int = loaded_data[VERSION_NAME]
	match format_version:
		1:
			return from_json_v1(loaded_data)
		_:
			return Error.new("unknown level encoding version: %d" % format_version)

static func from_json_v1(loaded_data):
	if not loaded_data.has(TITLE_NAME):
		return Error.missing_field(TITLE_NAME)
	var l_name = loaded_data[TITLE_NAME]
	if not loaded_data.has(BACKGROUND_NAME):
		return Error.missing_field(BACKGROUND_NAME)
	var loaded_background: Dictionary[Vector2i, bool] = {}
	for background_tile_string in loaded_data[BACKGROUND_NAME]:
		loaded_background[str_to_var(background_tile_string)] = true
	if not loaded_data.has(INPUTS_NAME):
		return Error.missing_field(INPUTS_NAME)
	var l_inputs: Array[PreInput] = []
	for input_description in loaded_data[INPUTS_NAME]:
		var input_tile = PreInput.from_description(input_description)
		if input_tile is Error:
			return input_tile.wrap("failed to load input tile")
		l_inputs.append(input_tile)
	if not loaded_data.has(OUTPUTS_NAME):
		return Error.missing_field(OUTPUTS_NAME)
	var l_outputs: Array[PreOutput] = []
	for output_description in loaded_data[OUTPUTS_NAME]:
		var output_tile = PreOutput.from_description(output_description, l_inputs)
		if output_tile is Error:
			return output_tile.wrap("failed to load output tile")
		l_outputs.append(output_tile)
	if not loaded_data.has(TILES_NAME):
		return Error.missing_field(TILES_NAME)
	var l_tiles: Array[PreTile] = []
	for tile_description in loaded_data[TILES_NAME]:
		var tile = PreTile.from_description_v1(tile_description)
		if tile is Error:
			return tile.wrap("failed to load tile")
		l_tiles.append(tile)
	return Level.new(l_name, loaded_background, l_inputs, l_outputs, l_tiles)

func to_description():
	var inputs_description = []
	for input in self.inputs:
		inputs_description.append(input.to_description())
	var outputs_description = []
	for output in self.outputs:
		outputs_description.append(output.to_description())
	var tiles_description = []
	for tile in self.tiles:
		tiles_description.append(tile.to_description())
	var background_tiles_to_save = []
	for background_tile in self.background.keys():
		background_tiles_to_save.append(var_to_str(background_tile))
	return {
		VERSION_NAME: 1,
		TITLE_NAME: self.name,
		BACKGROUND_NAME: background_tiles_to_save,
		INPUTS_NAME: inputs_description,
		OUTPUTS_NAME: outputs_description,
		TILES_NAME: tiles_description,
	}

func save_to_file():
	var filename = "%s/%s.json" % [USER_LEVEL_DIR, self.name]
	var level_file = FileAccess.open(filename, FileAccess.WRITE)
	level_file.store_string(JSON.stringify(to_description(), "\t", false))
