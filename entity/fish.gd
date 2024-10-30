extends Node2D
class_name Fish

const EAT_DIST:float = 10
const EAT_TO_LAY_TIME:float = 1.5
#const LAY_MAX:int = 3
const FISH_SCENE:PackedScene = preload("res://entity/fish.tscn")

const PERCEPTION_RADIUS:float = 40
const SEPARATION_DISTANCE:float = 25
const SPEED_MAX:float = 1.0

const ALIGNMENT_FORCE:float = .01
const COHESION_FORCE:float = .0001
const SEPARATION_FORCE:float = 2#1.2

const MOUSE_PERCEPTION_RADIUS:float = 100
const MOUSE_FORCE:float = .002

var direction:float = randf_range(0, TAU)
@onready var velocity:Vector2 = Util.vector_from_angle(SPEED_MAX, direction)

#const MAX_LIFESPAN:float = 20

#var lifespan_tween:Tween
var eat_tweens:Array[Tween] = []

func _exit_tree() -> void:
	for tween:Tween in eat_tweens: tween.kill()

#func _ready() -> void:
	#lifespan_tween = create_tween()
	#lifespan_tween.tween_callback(peacefully_die_of_old_age).set_delay(MAX_LIFESPAN * randf_range(.8,1.0))

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

	$Sprite.frame = posmod(round(velocity.angle() * 8 / TAU), 8)
	#$Label.text = "%s %s" % [posmod(round(velocity.angle() * 8 / TAU), 8) $Sprite.frame]
	position += velocity


	# EAT LARVAE
	var all_larvae:Array = get_tree().get_nodes_in_group("larvae")
	for larvae:Larvae in all_larvae:
		var distance := position.distance_to(larvae.position)
		if distance < EAT_DIST:
			larvae.queue_free()
			var eat_tween = create_tween()
			eat_tween.tween_callback(lay_fish).set_delay(EAT_TO_LAY_TIME)
			eat_tweens.append(eat_tween)

func lay_fish() -> void:
	#for i in randi_range(1, LAY_MAX):
	var fish:Fish = FISH_SCENE.instantiate()
	fish.position = position + Vector2(.01,.01)
	fish.velocity = velocity
	Main.scene.add_child(fish)

func peacefully_die_of_old_age() -> void:
	queue_free()
