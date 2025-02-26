extends Node2D
class_name Fish

const EAT_DIST:float = 3
const EAT_TO_LAY_TIME:float = 1.5
#const LAY_MAX:int = 3
@export var fish_scene:PackedScene

const PERCEPTION_RADIUS:float = 40
const SEPARATION_DISTANCE:float = 25
const SPEED_MAX:float = 1.0

const ALIGNMENT_FORCE:float = .01
const COHESION_FORCE:float = .0001
const SEPARATION_FORCE:float = 3#1.2

#const MOUSE_PERCEPTION_RADIUS:float = 100
const FOLLOW_FORCE:float = .0018
const FOLLOW_RADIUS:float = 100

var idle_point:Vector2
var following_player:bool = false

# offset the attraction to the player by a variable amount for each fish, and change that orbit point over time
var orbit:float = 0
@onready var variation_seed:float = randf()

@onready var direction:float = variation_seed * TAU
@onready var velocity:Vector2 = Util.vector_from_angle(SPEED_MAX, direction)

const MAX_LIFESPAN:float = 40

#var lifespan_tween:Tween
#var eat_tweens:Array[Tween] = []

#func _exit_tree() -> void:
	#for tween:Tween in eat_tweens: tween.kill()

func _ready() -> void:
	idle_point = position + Vector2(variation_seed,-variation_seed*2) * 2
	#lifespan_tween = create_tween()
	#lifespan_tween.tween_callback(peacefully_die_of_old_age).set_delay(MAX_LIFESPAN * randf_range(.8,1.0))

func _process(delta: float) -> void:
	#Util.wrap_screen(self)

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

	orbit += (variation_seed - .5) * delta * 4
	if orbit > TAU: orbit -= TAU
	elif orbit < 0: orbit += TAU
	var variation_offset := Util.vector_from_angle(variation_seed, orbit) * 60

	var player:Player = get_tree().get_first_node_in_group("player")
	var player_diff := (player.position + variation_offset) - position

	var follow_diff := Vector2.ZERO
	if following_player and player:
		follow_diff = player_diff
		if follow_diff.length() > FOLLOW_RADIUS:
			following_player = false
			idle_point = position
	else:
		follow_diff = idle_point - position
		if follow_diff.length() > FOLLOW_RADIUS:
			idle_point = position
		if player_diff.length() < FOLLOW_RADIUS:
			following_player = true

	follow_diff = follow_diff.limit_length(FOLLOW_RADIUS)
	velocity += follow_diff * FOLLOW_FORCE


	velocity = velocity.limit_length(SPEED_MAX)

	$Sprite.frame = posmod(round(velocity.angle() * 8 / TAU), 8)
	#$Label.text = "%s %s" % [posmod(round(velocity.angle() * 8 / TAU), 8) $Sprite.frame]
	position += velocity


	# EAT LARVAE
	#var all_larvae:Array = get_tree().get_nodes_in_group("larvae")
	#for larvae:Larvae in all_larvae:
		#var distance := position.distance_to(larvae.position)
		#if distance < EAT_DIST:
			#larvae.queue_free()
			#var eat_tween = create_tween()
			#eat_tween.tween_callback(lay_fish).set_delay(EAT_TO_LAY_TIME)
			#eat_tweens.append(eat_tween)

#func lay_fish() -> void:
	##for i in randi_range(1, LAY_MAX):
	#var fish:Fish = FISH_SCENE.instantiate()
	#fish.position = position + Vector2(.01,.01)
	#fish.velocity = velocity
	#Main.scene.add_child(fish)
#
#func peacefully_die_of_old_age() -> void:
	#queue_free()
