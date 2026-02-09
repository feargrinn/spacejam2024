class_name VictoryScreen
extends ColorRect

signal next_level_requested

@onready var next_level: Button = %NextLevel

func _ready() -> void:
	next_level.pressed.connect(next_level_requested.emit)
