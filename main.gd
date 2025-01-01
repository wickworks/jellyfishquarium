extends Node2D
class_name Main

# Singleton reference to this scene
static var scene: Main

# Scenes for fish and jellyfish (uncomment and replace with your actual paths if needed)
const FISH_SCENE: PackedScene = preload("res://entity/fish.tscn")
const JELLYFISH_SCENE: PackedScene = preload("res://entity/jellyfish.tscn")

# Initial spawns
const STARTING_JELLYFISH: int = 5
const STARTING_FISH: int = 30

# The player to be instanced. 
# In Godot 4, `InstancePlaceholder` can be used as a typed placeholder, 
# or define it as a Node if it's a standard scene.
@onready var player: InstancePlaceholder = $Player

# We store a reference to the game window (Godot 4 approach).
@onready var window: Window = get_window()

# The base size used for ratio-based resizing
@onready var base_size: Vector2i = window.content_scale_size

# For global mouse position if needed
static var mouse_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	randomize() # Ensure we seed the random number generator
	# Connect the window size changed signal (if not done via the editor).
	window.size_changed.connect(_on_window_size_changed)

	Main.scene = self
	# Optionally create animals at start
	#create_starting_animals()

func _on_window_size_changed() -> void:
	var ratio: Vector2 = window.size / base_size
	var chosen = (ratio.y if ratio.y >= ratio.x else ratio.x)
	window.content_scale_size = window.size / chosen

func create_starting_animals() -> void:
	var screen_size: Vector2 = get_viewport().get_visible_rect().size

	# Spawn fish
	for i in range(STARTING_FISH):
		var fish = FISH_SCENE.instantiate()
		fish.position = Vector2(
			rand_range(0.0, screen_size.x),
			rand_range(0.0, screen_size.y)
		)
		add_child(fish)

	# Spawn jellyfish
	for i in range(STARTING_JELLYFISH):
		var jellyfish = JELLYFISH_SCENE.instantiate()
		jellyfish.position = Vector2(
			rand_range(0.0, screen_size.x),
			rand_range(0.0, screen_size.y)
		)
		add_child(jellyfish)

func _process(delta: float) -> void:
	mouse_position = get_viewport().get_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		# Wipe out fish, jellyfish, or larvae
		for fish in get_tree().get_nodes_in_group("fish"):
			fish.queue_free()
		for j in get_tree().get_nodes_in_group("jellyfish"):
			j.queue_free()
		for larvae in get_tree().get_nodes_in_group("larvae"):
			larvae.queue_free()

		# Recreate them
		create_starting_animals()

func _on_shatterable_window_spawn_player(velocity: Vector2) -> void:
	var girl = player.create_instance(true)
	girl.velocity = velocity
	girl.game_over.connect(_on_player_game_over)

func _on_player_game_over() -> void:
	$GameOver.show()
