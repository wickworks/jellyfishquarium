extends CharacterBody2D
class_name Hook

const SPEED:float = 15
#const PULL_VELOCITY:float = 200
const PULL_ACCEL:float = 1250
const FIRE_DISTANCE:float = 10

const DESIRED_DISTANCE:float = 100

var is_hooked:bool = false
var release_action:StringName

func initialize(starting_pos:Vector2, angle:float, action:StringName) -> void:
	position = starting_pos + (Vector2.from_angle(angle) * FIRE_DISTANCE)
	velocity = Vector2.from_angle(angle) * SPEED
	release_action = action

func _process(delta:float) -> void:
	if not is_hooked and move_and_collide(velocity):
		is_hooked = true

func _input(event: InputEvent) -> void:
	if event.is_action_released(release_action):
		queue_free()

func get_pull_force(relative_player_pos:Vector2) -> Vector2:
	var clamped_distance:float = clampf(relative_player_pos.length(), DESIRED_DISTANCE * .5, DESIRED_DISTANCE * 1.25)
	var distance_mod:float = clamped_distance / DESIRED_DISTANCE
	var pull_vector:Vector2 = relative_player_pos.normalized() * -1
	return pull_vector * PULL_ACCEL * distance_mod

func update_line(relative_player_pos:Vector2) -> void:
	$Line2D.points[0] = relative_player_pos
