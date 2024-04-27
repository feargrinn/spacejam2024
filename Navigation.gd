extends Node

var esc_pressed = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE) and esc_pressed == false:
		esc_pressed = true
		if $GameScreen.is_visible():
			if $GameScreen/MarginContainer.is_visible():
				$GameScreen/MarginContainer.hide();
			else:
				$GameScreen/MarginContainer.show();
	if Input.is_action_just_released("ESC_PRESSED"):
		esc_pressed = false

func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	$MenuScreen.hide();
	get_tree().change_scene_to_file("res://game.tscn")

func _on_main_menu_pressed():
	$GameScreen/MarginContainer.hide();
	$GameScreen.hide()
	$MenuScreen.show();
