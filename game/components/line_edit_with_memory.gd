class_name LineEditWithMemory
extends LineEdit

var current_value: String = ""


func _ready() -> void:
	text_submitted.connect(_on_text_submitted)


func _gui_input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		text = current_value
		release_focus()


func _on_text_submitted(submitted_text: String) -> void:
	current_value = submitted_text
	release_focus()
