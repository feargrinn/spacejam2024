extends Button

func _on_pressed() -> void:
	get_tree().get_root().get_child(1)._on_next_level_pressed() #Terrible... TODO: refactor ofc
