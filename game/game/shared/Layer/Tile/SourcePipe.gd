class_name SourcePipe

var position: Vector2i
var flow_coefficient: int

func _init(pos: Vector2i, flow: int):
	self.position = pos
	self.flow_coefficient = flow
