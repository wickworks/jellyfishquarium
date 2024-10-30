extends Node2D

var direction:float = randf_range(0, TAU)
var speed:float = 1.0

func _process(delta: float) -> void:
	position += Util.vector_from_angle(speed, direction)

	Util.wrap_screen(self)
