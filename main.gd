extends Node2D
class_name Main

static var scene:Main

#const FISH_SCENE:PackedScene = preload("res://entity/fish.tscn")
#const JELLYFISH_SCENE:PackedScene = preload("res://entity/jellyfish.tscn")
#const STARTING_JELLYFISH:int = 5
#const STARTING_FISH:int = 30

#static var mouse_position:Vector2

func _ready() -> void:
	Main.scene = self
	#create_starting_animals()
#
#func create_starting_animals() -> void:
	#var screen_size := get_viewport().get_visible_rect().size
	#for i in STARTING_FISH:
		#var fish:Fish = FISH_SCENE.instantiate()
		#fish.position = Vector2(randi_range(0, screen_size.x), randi_range(0, screen_size.y))
		#add_child(fish)
#
	#for i in STARTING_JELLYFISH:
		#var jellyfish = JELLYFISH_SCENE.instantiate()
		#jellyfish.position = Vector2(randi_range(0, screen_size.x), randi_range(0, screen_size.y))
		#add_child(jellyfish)

#func _process(delta: float) -> void:
	#mouse_position = get_viewport().get_mouse_position()

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
#
		#for fish:Fish in get_tree().get_nodes_in_group("fish"): fish.queue_free()
		#for jellyfish:Jellyfish in get_tree().get_nodes_in_group("jellyfish"): jellyfish.queue_free()
		#for larvae:Larvae in get_tree().get_nodes_in_group("larvae"): larvae.queue_free()
#
		#create_starting_animals()
