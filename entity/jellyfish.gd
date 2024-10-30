extends Node2D

var velocity: Vector2 = Vector2(randf_range(-1.0, 1.0), 0.0)
var accel: Vector2 = Vector2(0, 0)
const ACCEL = 0.05
const DRAG = 0.3
const GRAVITY = 0.0005

func bloop() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'accel', Vector2(randf_range(-0.1, 0.1), -ACCEL), 0.3)
	tween.tween_property(self, 'accel', Vector2(0.0, 0), 0.3)
	tween.tween_interval(randf_range(3, 7))
	tween.tween_callback(bloop)

func _ready() -> void:
	bloop()

func _process(delta: float) -> void:
	velocity += accel
	velocity += Vector2(0, GRAVITY)
	var drag_force = max((velocity.length() ** 2) * DRAG, 0)
	velocity += (velocity.normalized() * drag_force * -1)
	position += velocity
	Util.wrap_screen(self)
