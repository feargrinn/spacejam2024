extends Node2D

func _ready() -> void:
	name = "Sounds"

func play(sound_name : String):
	get_node(sound_name).play()
