extends Node2D
class_name Fish

const PERCEPTION_RADIUS:float = 40
const SEPARATION_DISTANCE:float = 25
const SPEED_MAX:float = 1.0

const ALIGNMENT_FORCE:float = .01
const COHESION_FORCE:float = .0001
const SEPARATION_FORCE:float = 1.2

const MOUSE_PERCEPTION_RADIUS:float = 80
const MOUSE_FORCE:float = .002

var direction:float = randf_range(0, TAU)
@onready var velocity:Vector2 = Util.vector_from_angle(SPEED_MAX, direction)

func _process(delta: float) -> void:
	Util.wrap_screen(self)

	var average_velocity := Vector2.ZERO
	var average_position := Vector2.ZERO
	var average_separation := Vector2.ZERO
	var num_neighbors:int = 0

	var all_fish:Array = get_tree().get_nodes_in_group("fish")
	for other:Fish in all_fish:
		if other == self: continue

		var distance := position.distance_to(other.position)

		if distance < PERCEPTION_RADIUS:
			average_velocity += other.velocity
			average_position += other.position

			if distance < SEPARATION_DISTANCE:
				var diff:Vector2 = other.position - position
				diff = diff.limit_length(1.0 / distance)
				average_separation += diff

			num_neighbors += 1

	if num_neighbors > 0:
		average_velocity /= num_neighbors
		average_position /= num_neighbors
		average_separation /= num_neighbors

	velocity += average_velocity * ALIGNMENT_FORCE
	velocity += average_position * COHESION_FORCE
	velocity -= average_separation * SEPARATION_FORCE


	# and always know about the mouse
	var mouse_distance := position.distance_to(Main.mouse_position)
	if mouse_distance < MOUSE_PERCEPTION_RADIUS:
		var mouse_diff := Main.mouse_position - position
		mouse_diff = mouse_diff.limit_length(PERCEPTION_RADIUS)
		velocity += mouse_diff * MOUSE_FORCE

	velocity = velocity.limit_length(SPEED_MAX)
	position += velocity
