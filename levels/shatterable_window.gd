extends Control

@onready var shards:InstancePlaceholder = $WindowShards

func _ready() -> void:
	get_tree().create_timer(1.5).timeout.connect(shatter)

func shatter() -> void:
	$Window.hide()
	var shards_container:Node = shards.create_instance(true)
	for shard in shards_container.get_children():
		shard.velocity.y = -100.0
		shard.velocity.x = randf_range(-100, 100)
		shard.spin = shard.velocity.x / 20

	spawn_player.emit(Vector2(140, 0))

	$Camera2D.enabled = false

signal spawn_player(velocity)
