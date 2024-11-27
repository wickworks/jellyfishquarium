extends CharacterBody2D
class_name Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

const MAX_RUN := 90.0 * 2.0
const MAX_FALL := 160.0 * 2.0
const FAST_MAX_ACCEL := 300.0 * 2.0
const RUN_REDUCE := 400.0 * 2.0
const RUN_ACCEL := 1000.0 * 2.0
const GRAVITY := 900.0 * 2.0
const JUMP_H_BOOST := 40.0 * 2.0
const JUMP_SPEED := -105.0 * 2.0
const HALF_GRAV_THRESHOLD := 40.0 * 2.0
const VAR_JUMP_TIME = 0.2

var lift_speed := Vector2(0, 0)
var max_fall := 0.0
var var_jump_timer := 0.0

var lift_boost: Vector2:
	get:
		return Vector2(0, 0)

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
		
func _enter_tree():
	max_fall = MAX_FALL


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_x = Input.get_axis("Move left", "Move right")

	if var_jump_timer > 0:
		var_jump_timer -= delta
		

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

	# horizontal movement
	if absf(velocity.x) > MAX_RUN && signf(velocity.x) == move_x:
		velocity.x = _approach(velocity.x, MAX_RUN * move_x, RUN_REDUCE * delta)
	else:
		velocity.x = _approach(velocity.x, MAX_RUN * move_x, RUN_ACCEL * delta)
	if velocity.x != 0:
		$AnimatedSprite2D.scale.x = signf(velocity.x)
	
	
	# vertical movement
	var mf = MAX_FALL
	max_fall = _approach(max_fall, mf, FAST_MAX_ACCEL * delta)		

	if !is_on_floor():
		var max = max_fall
		var mult = 0.5 if (absf(velocity.y) < HALF_GRAV_THRESHOLD && (Input.is_action_pressed("Jump"))) else 1.0
		velocity.y = _approach(velocity.y, max, GRAVITY * mult * delta)
		
		
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		print("Jump! %s" % [max_fall])
		var_jump_timer = VAR_JUMP_TIME
		velocity.x += JUMP_H_BOOST * move_x
		velocity.y = JUMP_SPEED
		velocity += lift_boost
		$AnimatedSprite2D.scale = Vector2(0.6 * signf($AnimatedSprite2D.scale.x), 1.4)
		
	move_and_slide()
	
	
	for collision_i in range(get_slide_collision_count()):
		var collision = get_slide_collision(collision_i)
		if collision.get_normal() == Vector2.UP:
			var_jump_timer = 0
			$AnimatedSprite2D.scale = Vector2(1.0 * signf($AnimatedSprite2D.scale.x), 1.0)
			
			
	
