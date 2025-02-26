class_name Util


static func vector_from_angle(v_speed:float, v_angle:float) -> Vector2:
	return Vector2(
		v_speed * cos(v_angle),
		v_speed * sin(v_angle)
	)

static func vector3_from_angle(v_speed:float, v_angle:float) -> Vector3:
	return Vector3(
		v_speed * cos(v_angle),
		0,
		v_speed * sin(v_angle)
	)

static func wrap_screen(node:Node2D) -> void:
	var window_size := node.get_viewport().get_visible_rect().size
	while node.position.x > window_size.x: node.position.x -= window_size.x
	while node.position.y > window_size.y: node.position.y -= window_size.y
	while node.position.x < 0: node.position.x += window_size.x
	while node.position.y < 0: node.position.y += window_size.y


static func approach(value: float, target: float, amount: float) -> float:
	if value < target:
		return minf(value + amount, target)
	if value > target:
		return maxf(value - amount, target)
	else:
		return target

static func anim(obj, property, target: float, amount: float) -> void:
	obj.set(property, approach(obj.get(property), target, amount))

static func approach2d(value: Vector2, target: Vector2, amount: float) -> Vector2:
	return Vector2(
		approach(value.x, target.x, amount),
		approach(value.y, target.y, amount),
	)

static func approach3d(value: Vector3, target: Vector3, amount: Vector3) -> Vector3:
	return Vector3(
		approach(value.x, target.x, amount.x),
		approach(value.y, target.y, amount.y),
		approach(value.z, target.z, amount.z),
	)
	
# e.g. Util.get_screen_pos(player.position, player.get_viewport())
static func get_screen_position(world_pos:Vector3, viewport:Viewport) -> Vector2:
	var camera := viewport.get_camera_3d()
	return camera.unproject_position(world_pos)
