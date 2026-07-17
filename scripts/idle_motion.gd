extends Node3D
## Cheap idle animation for props and characters: vertical bob and/or
## Y-axis spin. Pure _process math — no AnimationPlayer, web-friendly.

@export var bob_amplitude: float = 0.0
@export var bob_speed: float = 2.0
@export var spin_degrees_per_second: float = 0.0

var _base_y: float = 0.0
var _elapsed: float = 0.0


func _ready() -> void:
	add_to_group("idle_motion")
	_base_y = position.y


func _process(delta: float) -> void:
	_elapsed += delta
	if bob_amplitude > 0.0:
		position.y = _base_y + sin(_elapsed * bob_speed) * bob_amplitude
	if spin_degrees_per_second != 0.0:
		rotate_y(deg_to_rad(spin_degrees_per_second) * delta)
