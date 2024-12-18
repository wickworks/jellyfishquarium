extends Area2D

@export var possible_sprites:Array[Texture2D]

@export var loose_clothes_scene:PackedScene


var has_clothes = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = possible_sprites.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: Node2D):
	if has_clothes:
		if &"velocity" in body:
			body.velocity.y = 0
		if body.has_method("catch"):
			body.catch()


		if has_clothes:
			has_clothes = false
			for i in range(randi_range(4,8)):
				var underwear = loose_clothes_scene.instantiate()
				underwear.position = position + Vector2(randf_range(-5, 5), randf_range(-5, 5))
				underwear.velocity.y = -100.0
				underwear.velocity.x = randf_range(-100, 100)
				get_parent().call_deferred(&'add_child', underwear)



func _on_body_exited(body):
	if body.has_method("release"):
		body.release()
