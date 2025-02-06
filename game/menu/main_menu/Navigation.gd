extends Node



func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://game.tscn")


func _on_create_pressed():
	get_tree().change_scene_to_file("res://editor.tscn")
