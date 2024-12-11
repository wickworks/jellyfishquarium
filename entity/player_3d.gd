extends CharacterBody3D


const JUMP_VELOCITY = 4.5


var var_jump_timer := 0.0
var var_jump_speed := 0.0

func _physics_process(delta):
	$"Rogue/Rig/Skeleton3D/1H_Crossbow".hide()
	$"Rogue/Rig/Skeleton3D/2H_Crossbow".hide()
	$"Rogue/Rig/Skeleton3D/Knife".hide()
	$"Rogue/Rig/Skeleton3D/Knife_Offhand".hide()


	if var_jump_timer > 0:
		var_jump_timer -= delta

		if var_jump_timer <= 0:
			var_jump_timer = 0


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var move = Input.get_vector("Move left", "Move right", "Move up", "Move down")

	if is_on_floor():
		if move.length() > 0:
			$Rogue/AnimationPlayer.play("Running_A")
		else:
			$Rogue/AnimationPlayer.play("Idle")

	const MAX_RUN := 10.0
	const RUN_ACCEL := 100.0
	const RUN_REDUCE := 40.0
#

	var v_ground = Vector2(velocity.x, velocity.z).rotated(+%Camera.rotation.y)
	var a_ground: Vector2
	if (absf(velocity.x) > MAX_RUN && signf(velocity.x) == move.x):
		a_ground.x = RUN_REDUCE
	else:
		a_ground.x = RUN_ACCEL

	if (absf(velocity.z) > MAX_RUN && signf(velocity.z) == move.y):
		a_ground.y = RUN_REDUCE
	else:
		a_ground.y = RUN_ACCEL
	v_ground.x = Util.approach(v_ground.x, MAX_RUN * move.x, a_ground.x * delta)
	v_ground.y = Util.approach(v_ground.y, MAX_RUN * move.y, a_ground.y * delta)

	v_ground = v_ground.rotated(-%Camera.rotation.y)



	const MAX_FALL := 20
	const HALF_GRAV_THRESHOLD := 40.0
	const GRAVITY := 90.0
	const VAR_JUMP_TIME = 0.2
	const JUMP_H_BOOST := 4.0
	const JUMP_SPEED := 16.50#-125.0
# vertical movement
	#if wallslide_x != 0: target_max_fall *= WALLSLIDE_V_MULT
	#if wallslide_x != 0: max_fall = MAX_FALL * WALLSLIDE_V_MULT
	#var max_fall = Util.approach(max_fall, MAX_FALL, MAX_FALL * delta)


	if !is_on_floor():
		var jump_mult := 1.0
		# hold jump to get a bit o anti gravity
		if (absf(velocity.y) < HALF_GRAV_THRESHOLD && (Input.is_action_pressed("Jump"))): jump_mult = 0.5

		velocity.y = Util.approach(velocity.y, -MAX_FALL, GRAVITY * jump_mult * delta)
		if velocity.y < 0:
			pass
			#$Rogue/AnimationPlayer.play("Jump_Full_Short")

	if Input.is_action_just_pressed("Jump"):
		if is_on_floor(): #or wallslide_x != 0:
			#print("Jump! %s" % [max_fall])
			$Rogue/AnimationPlayer.stop()
			$Rogue/AnimationPlayer.play("Jump_Start")
			$Rogue/AnimationPlayer.queue("Jump_Full_Long")
			var_jump_timer = VAR_JUMP_TIME
			v_ground += JUMP_H_BOOST * move
			velocity.y = JUMP_SPEED
			#velocity += lift_boost
			var_jump_speed = velocity.y
#
	if var_jump_timer > 0:
		if Input.is_action_pressed("Jump"):
			velocity.y = minf(velocity.y, var_jump_speed)
		else:
			var_jump_timer = 0
			#$Rogue/AnimationPlayer.play("Jump_Full_Short")


	velocity = Vector3(v_ground.x, velocity.y, v_ground.y)


	var direction = (transform.basis * Vector3(move.x, 0, move.y)).normalized().rotated(Vector3.UP, %Camera.rotation.y)
	if direction.length() > 0:
		$Rogue.look_at(global_position - direction)

	move_and_slide()

	# UPDATE CAMERA
	const SNAP_WEIGHT:float = 4
	const MIN_OFFSET:float = 8
	const ANCHOR_SPACING:float = 30
	var cam_pos:Vector3 = %Camera.global_position
	var player_pos:Vector3 = global_position + Vector3(MIN_OFFSET, 0, MIN_OFFSET)
	var closest_point := Vector3(
		floor(player_pos.x / ANCHOR_SPACING) * ANCHOR_SPACING,
		cam_pos.y,
		floor(player_pos.z / ANCHOR_SPACING) * ANCHOR_SPACING
	)
	%Camera.global_position = cam_pos.lerp(closest_point, SNAP_WEIGHT * delta)

	#if cam_pos.distance_to(closest_point) > 5:
	%Camera.look_at($Rogue.global_position)
