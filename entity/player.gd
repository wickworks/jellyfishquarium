extends CharacterBody2D
class_name Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

const MAX_RUN := 90.0
const RUN_REDUCE := 400.0
const RUN_ACCEL := 1000.0

enum State { Idle, Walking }

var state: State = State.Idle


var move_x := 0.0

func _approach(value: float, target: float, amount: float) -> float:
	if value < target:
		return minf(value + amount, target)
	if value > target:
		return maxf(value - amount, target)
	else:
		return target


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_x = Input.get_axis("Move left", "Move right")

	match state:
		State.Idle:
			if move_x != 0:
				state = State.Walking
				$AnimationPlayer.stop()
				$AnimationPlayer.play("walk")

		State.Walking:
			if move_x == 0:
				state = State.Idle
				$AnimationPlayer.stop()
				$AnimationPlayer.play("idle")

	if absf(velocity.x) > MAX_RUN && signf(velocity.x) == move_x:
		velocity.x = _approach(velocity.x, MAX_RUN * move_x, RUN_REDUCE * delta)
	else:
		velocity.x = _approach(velocity.x, MAX_RUN * move_x, RUN_ACCEL * delta)

	if velocity.x != 0:
		$AnimatedSprite2D.scale.x = signf(velocity.x)

	move_and_slide()

	#position.x = new_x
