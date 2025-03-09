extends Button

func _on_pressed() -> void:
	get_tree().get_root().get_child(0)._on_next_level_pressed()
