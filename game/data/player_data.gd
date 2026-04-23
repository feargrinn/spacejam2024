extends RefCounted
class_name PlayerData

const SAVE_FILENAME: String = "user://save.json"
const REACHED_LEVEL_NAME: String = "level"

static var instance: PlayerData

var reached_level: int


static func _static_init() -> void:
	var loaded_data = PlayerData.load_default()
	if loaded_data is Error:
		print("Failed to load game state: ", loaded_data.as_string(), ".")
		instance = PlayerData.new()
	else:
		instance = loaded_data


static func get_instance() -> PlayerData:
	return instance


static func load_default():
	return load_from_file(SAVE_FILENAME)


static func load_from_file(filename: String):
	if not FileAccess.file_exists(filename):
		return Error.no_file(filename)
	var save_file = FileAccess.open(SAVE_FILENAME, FileAccess.READ)
	var loaded_json = save_file.get_line()
	var result = load_from_json(loaded_json)
	if result is Error:
		return result.wrap("JSON loading error")
	else:
		return result


static func load_from_json(raw_json):
	var json = JSON.new()
	if not json.parse(raw_json) == OK:
		return Error.json_parse(raw_json, json)
	var loaded_data = json.get_data()
	if not loaded_data.has(REACHED_LEVEL_NAME):
		return Error.missing_field(REACHED_LEVEL_NAME)
	var result = PlayerData.new()
	result.reached_level = loaded_data[REACHED_LEVEL_NAME]
	return result


func _init():
	reached_level = 1


func save_game():
	var save_file = FileAccess.open(SAVE_FILENAME, FileAccess.WRITE)
	save_file.store_line(JSON.stringify({
		REACHED_LEVEL_NAME: reached_level
	}))
	save_file.close()


func unlock_level(level: int):
	if level > reached_level:
		reached_level = level
		save_game()


func get_reached_level():
	return reached_level
