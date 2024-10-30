extends Node2D
class_name Larvae

var angle:float
var speed:float

const SPEED_MAX:float = .5

const WAVER_TIME:float = 1.5


func _ready() -> void:
	angle = randf_range(0, TAU)
	speed = randf_range(SPEED_MAX * .5, SPEED_MAX)

	var waver_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_loops()
	waver_tween.tween_property(self, 'angle', angle - PI * .5, WAVER_TIME)
	waver_tween.tween_property(self, 'angle', angle + PI * .5, WAVER_TIME)
	waver_tween.tween_property(self, 'angle', angle, WAVER_TIME)

func _process(delta: float) -> void:
	position += Util.vector_from_angle(speed, angle)
