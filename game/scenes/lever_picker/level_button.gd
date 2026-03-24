class_name LevelButton
extends Button


func _init(level_name: String):
	set_text(level_name)
	custom_minimum_size = Vector2(64, 64)
