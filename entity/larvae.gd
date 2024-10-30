extends Node2D
class_name Larvae

const JELLYFISH_SCENE:PackedScene = preload("res://entity/jellyfish.tscn")


var angle:float
var speed:float

const SPEED_MAX:float = .5
const WAVER_TIME:float = 1.5
const MATURATION_TIME:float = 15

var waver_tween:Tween
var lifespan_tween:Tween

func _exit_tree() -> void:
	waver_tween.kill()
	lifespan_tween.kill()

func _ready() -> void:
	angle = randf_range(0, TAU)
	speed = randf_range(SPEED_MAX * .5, SPEED_MAX)

	waver_tween = create_tween()
	waver_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_loops()
	waver_tween.tween_property(self, 'angle', angle - PI * .5, WAVER_TIME)
	waver_tween.tween_property(self, 'angle', angle + PI * .5, WAVER_TIME)
	waver_tween.tween_property(self, 'angle', angle, WAVER_TIME)

	lifespan_tween = create_tween()
	lifespan_tween.tween_callback(grow_up_and_move_out).set_delay(MATURATION_TIME * randf_range(.5,1.0))

func _process(delta: float) -> void:
	position += Util.vector_from_angle(speed, angle)

func grow_up_and_move_out() -> void:
	var jellyfish:Jellyfish = JELLYFISH_SCENE.instantiate()
	jellyfish.position = position
	Main.scene.add_child(jellyfish)

	queue_free()
