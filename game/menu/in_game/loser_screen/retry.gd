extends Button


func _on_pressed() -> void:
	get_tree().get_root().get_child(1)._on_retry_pressed() # Just as terrible... TODO: also refactor
