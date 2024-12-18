extends CharacterBody2D

@export var possible_sprites:Array[Texture2D]

const MAX_FALL = 100
var max_fall = MAX_FALL

func _ready():
	$Sprite2D.texture = possible_sprites.pick_random()

func catch():
	max_fall = 0
	velocity.x = 0

func release():
	max_fall = MAX_FALL

func _process(delta):
	velocity.y = Util.approach(velocity.y,  max_fall, get_gravity().y * delta)
	move_and_slide()
