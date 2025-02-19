extends CharacterBody2D

@export var possible_sprites:Array[Texture2D]

const MAX_WEIGHT = 0.5
const MIN_WEIGHT = 0.2
var weight = randf_range(MIN_WEIGHT, MAX_WEIGHT)

var init_max_fall = lerpf(50, 150, weight / (MAX_WEIGHT - MIN_WEIGHT))
var max_fall = init_max_fall

var spin = 0

func _ready():
	$Sprite2D.texture = possible_sprites.pick_random()

func catch():
	max_fall = 0
	velocity.x = 0
	spin = 0

func release():
	max_fall = init_max_fall

func _process(delta):
	velocity.y = Util.approach(velocity.y,  max_fall, get_gravity().y * delta)
	rotation += spin * delta
	move_and_slide()
