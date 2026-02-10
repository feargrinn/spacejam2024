class_name MainMenu
extends Control


func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://menu/lever_picker/base_custom_picker.tscn")


func _on_create_pressed():
	get_tree().change_scene_to_file("res://game/editor/editor.tscn")
