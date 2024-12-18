extends Area2D

@export var possible_sprites:Array[Texture2D]
@export var empty_sprite:Texture2D

@export var loose_clothes_scene:PackedScene


var has_clothes = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = possible_sprites.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: Node2D):
	if not has_clothes:
		return

	if &"velocity" not in body or &"weight" not in body:
		return

	if body.weight > 50:
		has_clothes = false
		$Sprite2D.texture = empty_sprite

		for i in range(randi_range(4,8)):
			var underwear = loose_clothes_scene.instantiate()
			underwear.position = position + Vector2(randf_range(-5, 5), randf_range(-5, 5))
			underwear.velocity.y = -100.0
			underwear.velocity.x = randf_range(-100, 100)
			underwear.spin = underwear.velocity.x / 20
			get_parent().call_deferred(&'add_child', underwear)


	var power: float = absf(body.velocity.y) * body.weight

	var catch_amount = 200 - power / 5000
	if catch_amount > 0:
		body.velocity.y = Util.approach(body.velocity.y, 0, catch_amount)
		if body.has_method("catch"):
			body.catch()





func _on_body_exited(body):
	if body.has_method("release"):
		body.release()
