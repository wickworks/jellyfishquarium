extends Node2D
class_name Fish

const PERCEPTION_RADIUS:float = 60
const SEPARATION_DISTANCE:float = 40
const SPEED_MAX:float = 1.0

const ALIGNMENT_FORCE:float = 1
const COHESION_FORCE:float = 2
const SEPARATION_FORCE:float = 20
const FORCE_SCALAR:float = .00005

const MOUSE_FORCE:float = 10

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
				var diff:Vector2 = position - other.position
				diff = diff.limit_length(1.0 / distance)
				average_separation += diff

			num_neighbors += 1

	if num_neighbors > 0:
		average_velocity /= num_neighbors
		average_position /= num_neighbors
		average_separation /= num_neighbors

	velocity += average_velocity * (ALIGNMENT_FORCE * FORCE_SCALAR)
	velocity += average_position * (COHESION_FORCE * FORCE_SCALAR)
	velocity -= average_separation * (SEPARATION_FORCE * FORCE_SCALAR)

	#print(' avg vel %3f   pos %3f   sep  %3f' % [average_velocity.length(), average_position.length(), average_separation.length()])


	# and always know about the mouse
	#var mouse_seaverage_position += Main.mouse_position
	#if mouse_distance < SEPARATION_DISTANCE:
		#var diff:Vector2 = position - Main.mouse_position
		#diff = diff.limit_length(1 / mouse_distance)
		#average_separation += diff
	#var mouse_distance := position.distance_to(Main.mouse_position)
	#var mouse_diff := Main.mouse_position - position
	#mouse_diff = mouse_diff.limit_length(PERCEPTION_RADIUS)
	#velocity += mouse_diff * (MOUSE_FORCE * FORCE_SCALAR)
	#velocity -= average_separation * (SEPARATION_FORCE * FORCE_SCALAR)

	velocity = velocity.limit_length(SPEED_MAX)
	position += velocity
