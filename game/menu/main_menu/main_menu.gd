class_name MainMenu
extends PanelContainer

@onready var play: TextMarginButton = %Play
@onready var settings: TextMarginButton = %Settings
@onready var create: TextMarginButton = %Create
@onready var quit: TextMarginButton = %Quit


func _ready() -> void:
	play.pressed.connect(_on_play_pressed)
	create.pressed.connect(_on_create_pressed)
	quit.pressed.connect(get_tree().quit)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://menu/lever_picker/base_custom_picker.tscn")


func _on_create_pressed():
	get_tree().change_scene_to_file("res://game/editor/editor.tscn")
