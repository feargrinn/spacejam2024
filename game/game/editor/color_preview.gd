extends ColorRect

var red = 0
var yellow = 0
var blue = 0
var color_to_preview;

func _ready():
	red = $"../Red".value
	yellow = $"../Yellow".value
	blue = $"../Blue".value
	color_to_preview = Colour.new(red, yellow, blue)
	color = color_to_preview.color()

func _on_value_changed(_current_value) -> void:
	red = $"../Red".value
	yellow = $"../Yellow".value
	blue = $"../Blue".value
	color_to_preview = Colour.new(red, yellow, blue)
	color = color_to_preview.color()
	
