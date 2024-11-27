extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

const MAX_RUN := 90.0
const RUN_REDUCE := 400.0
const RUN_ACCEL := 1000.0


var move_x := 0.0
var speed: Vector2 = Vector2(0, 0)

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
	
	if absf(speed.x) > MAX_RUN && signf(speed.x) == move_x:
		speed.x = _approach(speed.x, MAX_RUN * move_x, RUN_REDUCE * delta)
	else:
		speed.x = _approach(speed.x, MAX_RUN * move_x, RUN_ACCEL * delta)
		
	position += speed * delta
