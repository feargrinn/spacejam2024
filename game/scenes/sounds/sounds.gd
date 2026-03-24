extends Node2D


func play(sound_name : String):
	get_node(sound_name).play()
