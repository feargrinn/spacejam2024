class_name Error

var text: String
var inner: Error

func _init(error_text: String):
	text = error_text

func wrap(error_text: String) -> Error:
	var wrapped = Error.new(error_text)
	wrapped.inner = self
	return wrapped

func as_string() -> String:
	if inner != null:
		return "%s: %s" % [text, inner.as_string()]
	else:
		return "%s" % text
