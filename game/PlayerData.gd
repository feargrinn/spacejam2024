class_name PlayerData

const save_filename = "user://save.json"
const reached_level_name = "level"

var reached_level = 1

func _init():
	load_game()

func save_game():
	var save_file = FileAccess.open(save_filename, FileAccess.WRITE)
	save_file.store_line(JSON.stringify({
		reached_level_name: reached_level
	}))

func load_game():
	# Set the default first, so that it's initialized to something.
	reached_level = 1
	if not FileAccess.file_exists(save_filename):
		print("No savegame detected.")
		return
	var save_file = FileAccess.open(save_filename, FileAccess.READ)
	var loaded_json = save_file.get_line()
	var json = JSON.new()
	if not json.parse(loaded_json) == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", loaded_json, " at line ", json.get_error_line())
		return
	var loaded_data = json.get_data()
	if not loaded_data.has(reached_level_name):
		print("Malformed save data, ignoring.")
		return
	reached_level = loaded_data[reached_level_name]

func unlock_level(level: int):
	if level > reached_level:
		reached_level = level
		save_game()

func get_reached_level():
	return reached_level
