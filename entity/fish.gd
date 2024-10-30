extends Node2D
class_name Fish

const sight_radius:float = 30

var direction:float = randf_range(0, TAU)
var speed:float = 1.0

func _process(delta: float) -> void:
	position += Util.vector_from_angle(speed, direction)

	Util.wrap_screen(self)





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
