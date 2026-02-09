class_name LoserScreen
extends ColorRect

signal retry_requested

@onready var retry_button: Button = %RetryButton

func _ready() -> void:
	retry_button.pressed.connect(retry_requested.emit)
