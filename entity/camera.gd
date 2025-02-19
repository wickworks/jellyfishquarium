extends Camera3D



@export var randomStrength := 0.3
@export var shakeFade := 0.2

var rng := RandomNumberGenerator.new()
var shake_strength := 0.0

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#game_bus.shake_camera.connect(apply_shake)

func apply_shake(force: float):
	shake_strength = randomStrength * force
	var tween = create_tween()
	tween.tween_property(self, "shake_strength", 0, shakeFade * force)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if shake_strength > 0:
		v_offset = rng.randf_range(-shake_strength, shake_strength)
		h_offset = rng.randf_range(-shake_strength, shake_strength)
	
