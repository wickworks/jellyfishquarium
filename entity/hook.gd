extends CharacterBody2D
class_name Hook

const SPEED:float = 10

var hooked:bool = false

func initialize(starting_pos:Vector2, angle:float) -> void:
	position = starting_pos
	velocity = Vector2.from_angle(angle) * SPEED

func _process(delta:float) -> void:
	if not hooked and move_and_collide(velocity):
		hooked = true

func _input(event: InputEvent) -> void:
	if event.is_action_released("fire_1"):
		queue_free()

func update_line(relative_player_pos:Vector2) -> void:
	$Line2D.points[0] = relative_player_pos
