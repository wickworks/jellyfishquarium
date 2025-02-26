extends CharacterBody3D
class_name Fairy

const PERCEPTION_RADIUS:float = 20
const SEPARATION_DISTANCE:float = 1

const SPEED_MAX:float = 10

const ALIGNMENT_FORCE:float = .01
const COHESION_FORCE:float = .01
const SEPARATION_FORCE:float = .01

const FOLLOW_FORCE:float = 5
const FOLLOW_FORCE_PLAYER:float = 10
const FOLLOW_RADIUS:float = 20

var idle_point:Vector3
var following_node:Node3D = null

# offset the attraction to the player by a variable amount for each fish, and change that orbit point over time
var orbit:float = 0
@onready var variation_seed:float = randf()

const IDLE_POINT_VARIATION:float = 1

#@onready var direction:float = variation_seed * TAU
#@onready var velocity:Vector3 = Util.vector3_from_angle(SPEED_MAX, direction)
@onready var spin_speed:float = randf_range(-.4, .4)

const MAX_LIFESPAN:float = 40

func _ready() -> void:
	idle_point = position #+ Vector3(IDLE_POINT_VARIATION,IDLE_POINT_VARIATION,IDLE_POINT_VARIATION) * (variation_seed - .5) * 2
	velocity = Util.vector3_from_angle(SPEED_MAX, variation_seed * TAU)

func _process(delta: float) -> void:
	$Body.rotation.y += spin_speed * TAU * delta

	var average_velocity := Vector3.ZERO
	var average_position := Vector3.ZERO
	var average_separation := Vector3.ZERO
	var num_neighbors:int = 0

	var all_fish:Array = get_tree().get_nodes_in_group(&"fairy")
	for other:Fairy in all_fish:
		if other == self: continue

		var distance := position.distance_to(other.position)

		if distance < PERCEPTION_RADIUS:
			average_velocity += other.velocity
			average_position += other.position

			if distance < SEPARATION_DISTANCE:
				var diff:Vector3 = other.position - position
				diff = diff.limit_length(1.0 / distance)
				average_separation += diff

			num_neighbors += 1

	if num_neighbors > 0:
		average_velocity /= num_neighbors
		average_position /= num_neighbors
		average_separation /= num_neighbors

	velocity += average_velocity * ALIGNMENT_FORCE * delta
	velocity += average_position * COHESION_FORCE * delta
	velocity -= average_separation * SEPARATION_FORCE * delta
#
	#orbit += (variation_seed - .5) * delta * 4
	#if orbit > TAU: orbit -= TAU
	#elif orbit < 0: orbit += TAU
	#var variation_offset := Util.vector3_from_angle(variation_seed, orbit) * 60
#
	var interesting_to_fairy_node:Player = get_tree().get_nodes_in_group("player").pick_random()
	var follow_node_diff := (interesting_to_fairy_node.position + Vector3(0,.5,0)) - position

	var follow_diff := Vector3.ZERO
	var follow_force:float = 0
	if following_node:
		follow_diff = follow_node_diff
		if follow_diff.length() > FOLLOW_RADIUS:
			following_node = null
			idle_point = position
		follow_force = FOLLOW_FORCE_PLAYER 
		if randf() < .01: print('follow dif interesting_to_fairy_node', follow_diff)
	else:
		follow_diff = idle_point - position
		if follow_diff.length() > FOLLOW_RADIUS:
			idle_point = position
		if follow_node_diff.length() < FOLLOW_RADIUS:
			following_node = interesting_to_fairy_node
		follow_force = FOLLOW_FORCE 
		if randf() < .01: print('follow dif idle', follow_diff)

	#velocity += follow_diff.normalized() * follow_force * delta

	#velocity = Util.approach3d(velocity, velocity.normalized() * SPEED_MAX, follow_diff.normalized() * follow_force * delta)

	velocity = velocity.limit_length(SPEED_MAX)

	#$Sprite.frame = posmod(round(velocity.angle() * 8 / TAU), 8)
	#$Label.text = "%s %s" % [posmod(round(velocity.angle() * 8 / TAU), 8) $Sprite.frame]
	#position += velocity

	move_and_slide()
