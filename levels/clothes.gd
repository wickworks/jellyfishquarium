extends Area2D

@export var possible_sprites:Array[Texture2D]

@export var loose_clothes_scene:PackedScene



# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = possible_sprites.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: Node2D):
	if body.has_method("catch"):
		body.catch()

		for i in range(randi_range(2,5)):
			var underwear = loose_clothes_scene.instantiate()
			get_parent().call_deferred(&'add_child', underwear)
