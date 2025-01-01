extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	%Sprite2D.position = Util.get_screen_position(global_position, get_viewport())


func _on_visibility_changed():
	%Sprite2D.visible = visible
