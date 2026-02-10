class_name LoserScreen
extends PanelContainer

signal retry_requested

const LOSER_SCREEN = preload("uid://drw6h3oglmj2e")

@onready var retry_button: Button = %RetryButton
@onready var color_difference: GridContainer = $VBoxContainer/ColorDifference


var losing_outputs: Dictionary


static func custom_new(incorrect_outputs: Dictionary) -> LoserScreen:
	var loser_screen: LoserScreen = LOSER_SCREEN.instantiate()
	loser_screen.losing_outputs = incorrect_outputs
	return loser_screen


func _ready() -> void:
	retry_button.pressed.connect(retry_requested.emit)
	
	for output in losing_outputs:
		_add_color_rect(losing_outputs[output]["target"])
		_add_color_rect(losing_outputs[output]["actual"])


func _add_color_rect(colour: Colour) -> void:
	var color_rect := ColorRect.new()
	color_difference.add_child(color_rect)
	color_rect.color = colour.color()
	
	color_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	color_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
