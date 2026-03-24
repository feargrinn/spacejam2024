extends Control

func play_credits():
	var delay = 500.
	$Credits.show()
	$RichTextLabel.show()
	$Credits.set_color("84A98C33")
	await get_tree().create_timer(delay/1000).timeout
	$Credits.set_color("84A98C66")
	await get_tree().create_timer(delay/1000).timeout
	$Credits.set_color("52796F99")
	await get_tree().create_timer(delay/1000).timeout
	$Credits.set_color("354F52CC")
	await get_tree().create_timer(delay/1000).timeout
	$Credits.set_color("2F3E46FF")
	await get_tree().create_timer(delay/1000).timeout
	while $RichTextLabel.position.y>-300:
		$RichTextLabel.position.y -= 10
		await get_tree().create_timer(delay/5000).timeout
		OS.delay_msec(delay/5);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_credits()
