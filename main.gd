extends Node2D
class_name Main

const FISH_SCENE:PackedScene = preload("res://entity/fish.tscn")
const JELLYFISH_SCENE:PackedScene = preload("res://entity/jellyfish.tscn")
const STARTING_FISH:int = 10
const STARTING_JELLYFISH:int = 5

static var mouse_position:Vector2

func _ready() -> void:
	var screen_size := get_viewport().get_visible_rect().size
	for i in STARTING_FISH:
		var fish:Fish = FISH_SCENE.instantiate()
		fish.position = Vector2(randi_range(0, screen_size.x), randi_range(0, screen_size.y))
		add_child(fish)
		
	for i in STARTING_JELLYFISH:
		var jellyfish = JELLYFISH_SCENE.instantiate()
		jellyfish.position = Vector2(randi_range(0, screen_size.x), randi_range(0, screen_size.y))
		add_child(jellyfish)

func _process(delta: float) -> void:
	mouse_position = get_viewport().get_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var screen_size := get_viewport().get_visible_rect().size
		var all_fish:Array = get_tree().get_nodes_in_group("fish")
		for fish:Fish in all_fish:
			fish.position = Vector2(randi_range(0, screen_size.x), randi_range(0, screen_size.y))
			fish.velocity = Util.vector_from_angle(Fish.SPEED_MAX, randf_range(0, TAU))
