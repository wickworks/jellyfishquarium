extends CharacterBody2D
class_name Hook

const SPEED:float = 15
#const PULL_VELOCITY:float = 200
const PULL_ACCEL:float = 1500

const FIRE_DISTANCE:float = 10

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

func update_line(relative_player_pos:Vector2) -> void:
	$Line2D.points[0] = relative_player_pos
