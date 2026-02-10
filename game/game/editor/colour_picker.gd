class_name ColourPicker
extends VBoxContainer

signal picked_colour(colour: Colour)

@onready var red: HSlider = %Red
@onready var yellow: HSlider = %Yellow
@onready var blue: HSlider = %Blue
@onready var color_preview: ColorRect = %ColorPreview
@onready var confirm: Button = %Confirm

var colour: Colour


func _ready() -> void:
	red.value_changed.connect(_on_value_changed.unbind(1))
	yellow.value_changed.connect(_on_value_changed.unbind(1))
	blue.value_changed.connect(_on_value_changed.unbind(1))
	confirm.pressed.connect(_on_confirm_pressed)
	_on_value_changed()


func _on_value_changed() -> void:
	colour = Colour.new(red.value, yellow.value, blue.value)
	color_preview.color = colour.color()


func _on_confirm_pressed() -> void:
	picked_colour.emit(colour)
