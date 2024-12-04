class_name Util


static func vector_from_angle(v_speed:float, v_angle:float) -> Vector2:
	return Vector2(
		v_speed * cos(v_angle),
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
