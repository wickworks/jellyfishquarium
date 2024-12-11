extends CharacterBody3D


const JUMP_VELOCITY = 4.5

func _physics_process(delta):

	$Rogue/AnimationPlayer.play("Running_A")
	$"Rogue/Rig/Skeleton3D/1H_Crossbow".hide()
	$"Rogue/Rig/Skeleton3D/2H_Crossbow".hide()
	$"Rogue/Rig/Skeleton3D/Knife".hide()
	$"Rogue/Rig/Skeleton3D/Knife_Offhand".hide()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
	velocity = Vector3(v_ground.x, velocity.y, v_ground.y)

	print(move,MAX_RUN * move.y, v_ground, a_ground, velocity, delta)

	var direction = (transform.basis * Vector3(move.x, 0, move.y)).normalized().rotated(Vector3.UP, %Camera.rotation.y)
	if direction.length() > 0:
		$Rogue.look_at(global_position - direction)


	%Camera.look_at($Rogue.global_position)

	move_and_slide()
