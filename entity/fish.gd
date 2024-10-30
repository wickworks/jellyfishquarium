extends Node2D
class_name Fish

const sight_radius:float = 30

var direction:float = randf_range(0, TAU)
var speed:float = 1.0

func _process(delta: float) -> void:
	position += vector(speed, direction)

	# WRAP
	var window_size := get_viewport().get_visible_rect().size
	if position.x > window_size.x: position.x -= window_size.x
	if position.y > window_size.y: position.y -= window_size.y
	if position.x < 0: position.x += window_size.x
	if position.y < 0: position.y += window_size.y



static func vector(v_speed:float, v_angle:float) -> Vector2:
	return Vector2(
		v_speed * cos(v_angle),
		v_speed * sin(v_angle)
	)


func coherence() -> Vector2:
	var close_fish_count:int = 0
	var average_nearby_pos := Vector2.ZERO
	var all_fish:Array = get_tree().get_nodes_in_group("fish")
	for fish:Fish in all_fish:
		if fish != self:
			if position.distance_to(fish.position) < sight_radius:
				close_fish_count += 1
				average_nearby_pos += fish.position

	if average_nearby_pos != Vector2.ZERO:
		average_nearby_pos /= all_fish.size()

	return average_nearby_pos
