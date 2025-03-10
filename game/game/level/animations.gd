extends Node2D

var winning_sprites = []
var losing_sprites = []
var losing_outputs : Dictionary

var game

func _ready() -> void:
	game = get_parent().get_parent()

func animate_loss(a_losing_outputs : Dictionary, tile_layer):
	losing_outputs = a_losing_outputs
	game.sound_system.play("losing")
	for output in losing_outputs:
		var sprite_losing = $LosingAnimation.duplicate(8)
		add_child(sprite_losing)
		for n in tile_layer.get_cell_alternative_tile(output):
			sprite_losing.rotation_degrees += 90
		sprite_losing.position = tile_layer.map_to_local(output)
		sprite_losing.visible = true
		losing_sprites.append(sprite_losing)
	$LosingAnimation/AnimationPlayerLosing.play("losing")
	for sprite in losing_sprites:
		sprite.get_child(0).play("losing")

func animate_win(all_outputs : Array[Vector2i], tile_layer : TileLayer):
	game.sound_system.play("winning")
	for output in all_outputs:
		var sprite_winning = $WinningAnimation.duplicate(8)
		add_child(sprite_winning)
		for n in tile_layer.get_cell_alternative_tile(output):
			sprite_winning.rotation_degrees += 90
		sprite_winning.position = tile_layer.map_to_local(output)
		sprite_winning.visible = true
		winning_sprites.append(sprite_winning)
	$WinningAnimation/AnimationPlayerWinning.play("winning")
	for sprite in winning_sprites:
		sprite.get_child(0).play("winning")


func _on_animation_player_winning_finished(_anim_name: StringName) -> void:
	for sprite in winning_sprites:
		sprite.queue_free()
	game.victory_screen()


func _on_animation_player_losing_finished(_anim_name: StringName) -> void:
	for sprite in losing_sprites:
		sprite.queue_free()
	game.loser_screen(losing_outputs)
