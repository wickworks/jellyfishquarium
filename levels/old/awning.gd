extends Area2D

@export var possible_sprites:Array[Texture2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = possible_sprites.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: Node2D):
	const AWNING_BOUNCE = 0.45
	const AWNING_PASS_THRU_SPEED = 200.0


	if &"velocity" not in body or &"weight" not in body:
		return


	var power: float = absf(body.velocity.y) * body.weight
	var catch_amount = 200 - power / 300
	if catch_amount > 0:
		if absf(body.velocity.y) > AWNING_PASS_THRU_SPEED:
			body.velocity.y = -body.velocity.y * AWNING_BOUNCE
			if body.has_method("bounce"):
				body.bounce()
		else:
			body.velocity.y = Util.approach(body.velocity.y, 0, catch_amount)
			if body.has_method("catch"):
				body.catch()
	else:
		body.velocity.y = Util.approach(body.velocity.y, 0, 200)


func _on_body_exited(body):
	if body.has_method("release"):
		body.release()
	pass # Replace with function body.
