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
	if &"velocity" in body:
		if absf(body.velocity.y) > AWNING_PASS_THRU_SPEED:
			body.velocity.y = -body.velocity.y * AWNING_BOUNCE
			if body.has_method("bounce"):
				body.bounce()
		else:
			body.velocity.y = 0
			if body.has_method("catch"):
				body.catch()


func _on_body_exited(body):
	if body.has_method("release"):
		body.release()
	pass # Replace with function body.
