class_name Util


static func vector_from_angle(v_speed:float, v_angle:float) -> Vector2:
	return Vector2(
		v_speed * cos(v_angle),
		v_speed * sin(v_angle)
	)


static func wrap_screen(node:Node2D) -> void:
	var window_size := node.get_viewport().get_visible_rect().size
	if node.position.x > window_size.x: node.position.x -= window_size.x
	if node.position.y > window_size.y: node.position.y -= window_size.y
	if node.position.x < 0: node.position.x += window_size.x
	if node.position.y < 0: node.position.y += window_size.y
