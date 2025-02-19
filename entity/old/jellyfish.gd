extends Node2D
class_name Jellyfish

const EAT_DIST:float = 10
const EAT_TO_LAY_TIME:float = 1.5
const LAY_MAX:int = 6
const LARVAE_SCENE:PackedScene = preload("res://entity/larvae.tscn")

var velocity: Vector2 = Vector2(randf_range(-1.0, 1.0), 0.0)
var accel: Vector2 = Vector2(0, 0)
const ACCEL = 0.05
const DRAG = 0.3
const GRAVITY = 0.0005

const MAX_LIFESPAN:float = 15

var lifespan_tween:Tween
var bloop_tween:Tween
var eat_tweens:Array[Tween] = []

func _exit_tree() -> void:
	lifespan_tween.kill()
	bloop_tween.kill()
	for tween:Tween in eat_tweens: tween.kill()

func bloop() -> void:
	bloop_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	bloop_tween.tween_property($Sprite, 'frame', 1, 0.4)
	bloop_tween.tween_property(self, 'accel', Vector2(randf_range(-0.1, 0.1), -ACCEL), 0.3)
	bloop_tween.parallel().tween_property($Sprite, 'frame', 3, 0.3)
	bloop_tween.chain().tween_property(self, 'accel', Vector2(0.0, 0), 0.3)
	bloop_tween.tween_property($Sprite, 'frame', 0, 0).set_delay(1.1)
	bloop_tween.tween_interval(randf_range(3, 7))
	bloop_tween.tween_callback(bloop)

func _ready() -> void:
	bloop()

	lifespan_tween = create_tween()
	lifespan_tween.tween_callback(peacefully_die_of_old_age).set_delay(MAX_LIFESPAN * randf_range(.75,1.0))

func _process(delta: float) -> void:
	velocity += accel
	velocity += Vector2(0, GRAVITY)
	var drag_force = max((velocity.length() ** 2) * DRAG, 0)
	velocity += (velocity.normalized() * drag_force * -1)
	position += velocity
	Util.wrap_screen(self)

	# EAT FISH
	var all_fish:Array = get_tree().get_nodes_in_group("fish")
	for fish:Fish in all_fish:
		var distance := position.distance_to(fish.position)
		if distance < EAT_DIST:
			fish.queue_free()
			var eat_tween = create_tween()
			eat_tween.tween_callback(lay_larvae).set_delay(EAT_TO_LAY_TIME)
			eat_tweens.append(eat_tween)


func lay_larvae() -> void:
	for i in randi_range(0, LAY_MAX):
		var larvae:Larvae = LARVAE_SCENE.instantiate()
		larvae.position = position
		Main.scene.add_child(larvae)


func peacefully_die_of_old_age() -> void:
	queue_free()
