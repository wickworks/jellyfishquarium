extends Area2D

@export var possible_sprites:Array[Texture2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = possible_sprites.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: Node2D):
	if body.has_method("bounce"):
		body.bounce()
