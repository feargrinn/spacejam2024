class_name LoserScreen
extends ColorRect

signal retry_requested

@onready var retry_button: Button = %RetryButton

@onready var target_list: VBoxContainer = %TargetList
@onready var gotten_list: VBoxContainer = %GottenList


func _ready() -> void:
	retry_button.pressed.connect(retry_requested.emit)
