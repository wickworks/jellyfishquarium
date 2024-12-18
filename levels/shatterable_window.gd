extends Control

@onready var shards:InstancePlaceholder = $WindowShards
@onready var player:InstancePlaceholder = $Player

func _ready() -> void:
	get_tree().create_timer(1.5).timeout.connect(shatter)

func shatter() -> void:
	$Window.hide()
	var shards_container:Node = shards.create_instance(true)
	for shard in shards_container.get_children():
		shard.velocity.y = -100.0
		shard.velocity.x = randf_range(-100, 100)
		shard.spin = shard.velocity.x / 20

	var girl = player.create_instance(true)
	girl.velocity.x = 140

	$Camera2D.enabled = false
