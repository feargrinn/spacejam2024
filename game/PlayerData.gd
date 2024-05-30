class_name PlayerData

const save_filename: String = "user://save.json"
const reached_level_name: String = "level"

var reached_level: int

func _init():
	reached_level = 1

func save_game():
	var save_file = FileAccess.open(save_filename, FileAccess.WRITE)
	save_file.store_line(JSON.stringify({
		reached_level_name: reached_level
	}))

static func load_default():
	return load_from_file(save_filename)

static func load_from_file(filename: String):
	if not FileAccess.file_exists(filename):
		return Error.new("file %s does not exist" % filename)
	var save_file = FileAccess.open(save_filename, FileAccess.READ)
	var loaded_json = save_file.get_line()
	var result = load_from_json(loaded_json)
	if result is Error:
		return result.wrap("JSON loading error")
	else:
		return result

static func load_from_json(raw_json):
	var json = JSON.new()
	if not json.parse(raw_json) == OK:
		return Error.new("JSON Parse Error: %s in %s at line %d." % [json.get_error_message(), raw_json, json.get_error_line()])
	var loaded_data = json.get_data()
	if not loaded_data.has(reached_level_name):
		return Error.new("missing %s" % reached_level_name)
	var result = PlayerData.new()
	result.reached_level = loaded_data[reached_level_name]
	return result

func unlock_level(level: int):
	if level > reached_level:
		reached_level = level
		save_game()

func get_reached_level():
	return reached_level
