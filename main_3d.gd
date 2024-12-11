extends Node3D
class_name Main3d

static var scene:Main3d

@onready var window: Window = get_window()
@onready var base_size: Vector2i = window.content_scale_size

func _ready() -> void:
	window.size_changed.connect(window_size_changed)
	Main3d.scene = self


func window_size_changed():
	var ratio: Vector2i = window.size/base_size
	window.content_scale_size = window.size / (ratio.y if ratio.y >= ratio.x else ratio.x)
