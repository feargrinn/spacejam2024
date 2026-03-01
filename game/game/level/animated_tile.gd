class_name AnimatedTile
extends AnimatedSprite2D

const WIN_LOSS_SPRITE_FRAMES = preload("uid://cllajbysnipu1")


func _init(animation_name: String) -> void:
	autoplay = animation_name
	animation_finished.connect(queue_free)


func _ready() -> void:
	sprite_frames = WIN_LOSS_SPRITE_FRAMES
	play()
