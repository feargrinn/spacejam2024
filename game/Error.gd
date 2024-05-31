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

static func no_file(filename: String) -> Error:
	return Error.new("file %s does not exist" % filename)

static func json_parse(raw_json, json) -> Error:
	return Error.new("JSON Parse Error: %s in %s at line %d." % [json.get_error_message(), raw_json, json.get_error_line()])

static func missing_field(field: String):
	return Error.new("missing field: %s" % field)
