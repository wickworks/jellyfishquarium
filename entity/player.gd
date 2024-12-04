extends CharacterBody2D
class_name Player

const HOOK_SCENE:PackedScene = preload("res://entity/hook.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

const AIR_CONTROL_THRESHOLD := 95 # moving faster than this and we lose air control
const AIR_REDUCE := 100.0

const MAX_RUN := 90.0
const MAX_FALL := 160.0
const FAST_MAX_ACCEL := 300.0
const RUN_REDUCE := 400.0
const RUN_ACCEL := 1000.0
const GRAVITY := 900.0
const JUMP_H_BOOST := 40.0
const JUMP_SPEED := -125.0
const HALF_GRAV_THRESHOLD := 40.0
const VAR_JUMP_TIME = 0.2

var lift_speed := Vector2(0, 0)
var max_fall := 0.0
var var_jump_timer := 0.0
var var_jump_speed := 0.0
var look_x := 0.0
var look_dx := 0.0

var lift_boost: Vector2:
	get:
		return Vector2(0, 0)

enum State { Idle, Walking }


var state: State = State.Idle


var move_x := 0.0


func _enter_tree():
	max_fall = MAX_FALL


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var has_latched_grappling_hook := $Hooks.get_children().any(func(hook:Hook) -> bool: return hook.is_hooked)

	move_x = Input.get_axis("Move left", "Move right")

	if var_jump_timer > 0:
		var_jump_timer -= delta

		if var_jump_timer <= 0:
			var_jump_timer = 0


	if is_on_floor():
		if move_x != 0:
			$AnimationPlayer.play("walk")
		else:
			$AnimationPlayer.play("idle")
	else:
		if velocity.y > 5:
			$AnimationPlayer.play("fall")

	# horizontal movement
	var accel_x
	if (not is_on_floor() and absf(velocity.x) > AIR_CONTROL_THRESHOLD) or has_latched_grappling_hook:
		accel_x = AIR_REDUCE
	elif (absf(velocity.x) > MAX_RUN && signf(velocity.x) == move_x):
		accel_x = RUN_REDUCE
	else:
		accel_x = RUN_ACCEL

	velocity.x = Util.approach(velocity.x, MAX_RUN * move_x, accel_x * delta)
	if velocity.x != 0:
		$AnimatedSprite2D.scale.x = signf(velocity.x)


	# vertical movement
	var mf = MAX_FALL
	max_fall = Util.approach(max_fall, mf, FAST_MAX_ACCEL * delta)

	if !is_on_floor():
		var max = max_fall
		var mult = 0.5 if (absf(velocity.y) < HALF_GRAV_THRESHOLD && (Input.is_action_pressed("Jump"))) else 1.0
		velocity.y = Util.approach(velocity.y, max, GRAVITY * mult * delta)
		if velocity.y > 0:
			$AnimationPlayer.play("fall")


	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		print("Jump! %s" % [max_fall])
		$AnimationPlayer.stop()
		$AnimationPlayer.play("jump")
		var_jump_timer = VAR_JUMP_TIME
		velocity.x += JUMP_H_BOOST * move_x
		velocity.y = JUMP_SPEED
		velocity += lift_boost
		var_jump_speed = velocity.y

	if var_jump_timer > 0:
		if Input.is_action_pressed("Jump"):
			velocity.y = minf(velocity.y, var_jump_speed)
		else:
			var_jump_timer = 0
			#$AnimationPlayer.stop()
			#$AnimationPlayer.play("fall")

	# update hooks
	for hook:Hook in $Hooks.get_children():
		update_hook(hook, delta)

	move_and_slide()

	for collision_i in range(get_slide_collision_count()):
		var collision = get_slide_collision(collision_i)
		if collision.get_normal() == Vector2.UP:
			var_jump_timer = 0


	const CAMERA_OFFSET := -70.0
	const LOOK_DISTANCE = 50.0
	const LOOK_SPEED = MAX_RUN
	const LOOK_ACCEL = 10.0


	var new_look_x = LOOK_DISTANCE * signf(velocity.x)

	if velocity.x != 0 and (signf(new_look_x) != signf(look_x) or absf(new_look_x) > absf(look_x)):
		look_dx = Util.approach(look_dx, LOOK_SPEED, LOOK_ACCEL)
		look_x = Util.approach(look_x, new_look_x, look_dx * delta)
	else:
		look_dx = Util.approach(look_dx, 0, LOOK_ACCEL)
	%CameraOffset.position.x = look_x





func _input(event: InputEvent) -> void:
	var mouse_pos := get_global_mouse_position()
	var firing_angle := global_position.angle_to_point(mouse_pos)
	for action:StringName in [&'fire_1', &'fire_2']:
		if event.is_action_pressed(action):
			create_hook(firing_angle, action)

func create_hook(angle:float, action:StringName) -> void:
	var new_hook:Hook = HOOK_SCENE.instantiate()
	$Hooks.add_child(new_hook)
	new_hook.initialize(global_position, angle, action)

func update_hook(hook:Hook, delta:float) -> void:
	hook.update_line(global_position - hook.global_position)

	if hook.is_hooked:
		#var pull_vector: = Vector2.from_angle(global_position.angle_to_point(hook.global_position)) * Hook.PULL_VELOCITY
		#velocity = Util.approach2d(velocity, pull_vector, Hook.PULL_ACCEL)
		var pull_force: = Vector2.from_angle(global_position.angle_to_point(hook.global_position)) * Hook.PULL_ACCEL
		velocity += (pull_force * delta)
