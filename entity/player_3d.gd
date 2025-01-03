extends CharacterBody3D


const JUMP_VELOCITY = 4.5
const JUMP_H_BOOST := 4.0
const GRAVITY := 90.0

var var_jump_timer := 0.0
var var_jump_speed := 0.0

class RailGrind:
	var rail:Rail
	var offset: float
	var velocity: float

var rail_grind: RailGrind = null

func _ready():
	$"Rogue/Rig/Skeleton3D/1H_Crossbow".hide()
	$"Rogue/Rig/Skeleton3D/2H_Crossbow".hide()
	$"Rogue/Rig/Skeleton3D/Knife".hide()
	$"Rogue/Rig/Skeleton3D/Knife_Offhand".hide()

func _physics_process(delta):
	var jump = false
	if rail_grind:
		jump = process_grind(rail_grind, delta)
	else:
		jump = process_skating(delta)


	const VAR_JUMP_TIME = 0.2
	const JUMP_SPEED := 16.50#-125.0

	if jump: #or wallslide_x != 0:
		$Rogue/AnimationPlayer.stop()
		$Rogue/AnimationPlayer.play("Jump_Start")
		$Rogue/AnimationPlayer.queue("Jump_Full_Long")
		var_jump_timer = VAR_JUMP_TIME
		velocity.y = JUMP_SPEED
		#velocity += lift_boost
		var_jump_speed = velocity.y

	# UPDATE CAMERA
	const MIN_FOLLOW_DISTANCE:float = 5
	const MAX_FOLLOW_DISTANCE:float = 10
	const LERP_WEIGHT:float = 4
	const MIN_OFFSET:float = 8
	const ANCHOR_SPACING:float = 30
	var cam_pos:Vector3 = %Camera.global_position
	var player_pos:Vector3 = global_position
	var cam_base_pos:Vector2 = Vector2(cam_pos.x, cam_pos.z)
	var player_base_pos:Vector2 = Vector2(player_pos.x, player_pos.z)
	var base_distance := (player_base_pos - cam_base_pos).length()

	var pull_to_distance:float = 0
	if base_distance > MAX_FOLLOW_DISTANCE:
		pull_to_distance = MAX_FOLLOW_DISTANCE
	elif base_distance < MIN_FOLLOW_DISTANCE:
		pull_to_distance = MIN_FOLLOW_DISTANCE

	if pull_to_distance != 0:
		var angle_to_base:float = player_base_pos.angle_to_point(cam_base_pos)
		var follow_offset := Vector2(cos(angle_to_base) * MIN_FOLLOW_DISTANCE, sin(angle_to_base) * MIN_FOLLOW_DISTANCE)
		var target_pos := player_base_pos + follow_offset
		%Camera.global_position = cam_pos.lerp(Vector3(target_pos.x, cam_pos.y, target_pos.y), LERP_WEIGHT * delta)

	#if cam_pos.distance_to(closest_point) > 5:
	%Camera.look_at($Rogue.global_position)

func process_grind(grind: RailGrind, delta):
	%GrindTarget.hide()
	const GRIND_SPEED = 20.0
	var curve_transform = grind.rail.path.sample_baked_with_rotation(grind.offset)
	var gravity_accel = curve_transform.basis.z.dot(Vector3.DOWN) * GRAVITY

	grind.velocity += gravity_accel * delta
	grind.offset -= delta * grind.velocity
	var new_position = grind.rail.to_global(curve_transform.origin)
	velocity = (new_position - position) / delta
	move_and_slide()

	var collided = get_slide_collision_count() > 0
	var hit_end = grind.offset >= grind.rail.path.get_baked_length() or grind.offset <= 0




	if Input.is_action_just_pressed("Jump") or hit_end or collided:
		velocity = curve_transform.basis.z * grind.velocity
		rail_grind = null
		return true


	return false




func get_move():
	return Input.get_vector("Move left", "Move right", "Move up", "Move down")

func process_skating(delta):
	if var_jump_timer > 0:
		var_jump_timer -= delta

		if var_jump_timer <= 0:
			var_jump_timer = 0

	var move = get_move()

	if is_on_floor():
		if move.length() > 0:
			$Rogue/AnimationPlayer.play("Running_A")
		else:
			$Rogue/AnimationPlayer.play("Idle")

	const MAX_RUN := 20.0
	const RUN_ACCEL := 70.0
	const RUN_REDUCE := 70.0
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


	const MAX_RAIL_LATCH = 3.0
	var closest_rail = null
	for rail in get_tree().get_nodes_in_group("rails"):
		var position_in_railspace = rail.to_local(self.global_position)
		var offset = rail.path.get_closest_offset(position_in_railspace)
		var attach_info: Transform3D = rail.path.sample_baked_with_rotation(offset)
		var closest_point = rail.to_global(attach_info.origin)
		var distance = (closest_point - global_position).length()
		if distance < MAX_RAIL_LATCH and (not closest_rail or distance < closest_rail.distance):
			closest_rail = {
				distance=distance,
				rail=rail,
				latch_point=closest_point,
				forward=attach_info.basis.z,
				offset=offset
			}

	if closest_rail:
		%GrindTarget.global_position = closest_rail.latch_point
		%GrindTarget.show()

		if not is_on_floor() and Input.is_action_just_pressed("Jump"):
			const GRIND_BOOST = 10.0
			rail_grind = RailGrind.new()
			rail_grind.offset = closest_rail.offset
			rail_grind.rail = closest_rail.rail
			rail_grind.velocity = closest_rail.forward.dot(velocity)
			rail_grind.velocity += GRIND_BOOST * signf(rail_grind.velocity)

	else:
		%GrindTarget.hide()

	return Input.is_action_just_pressed("Jump") and is_on_floor()
