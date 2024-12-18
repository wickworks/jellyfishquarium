extends Node2D

@export var possible_sprites:Array[Texture2D]

func _ready():
	$Sprite2D.texture = possible_sprites.pick_random()
