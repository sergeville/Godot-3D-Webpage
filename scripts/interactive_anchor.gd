extends Area3D
## Clickable 3D element ("interactive anchor" in the technical brief).
## Click (press + release without dragging) emits anchor_clicked; dragging
## horizontally past DRAG_THRESHOLD instead spins the node at
## spin_target_path (grab-to-spin, dreiraum-inspired). Optionally opens an
## external URL directly (social profiles, external pages).

signal anchor_clicked(anchor_id: String)

const HOVER_OVERLAY := preload("res://materials/hover_overlay.tres")
const DRAG_THRESHOLD := 8.0
const SPIN_RADIANS_PER_PX := 0.012

@export var anchor_id: String = "anchor"
@export var external_url: String = ""
@export var spin_target_path: NodePath

var _spin_target: Node3D
var _pressed := false
var _drag_accum := 0.0


func _ready() -> void:
	add_to_group("interactive_anchors")
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	if spin_target_path != NodePath(""):
		_spin_target = get_node(spin_target_path)
	set_process_input(false)


func _on_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_pressed = true
		_drag_accum = 0.0
		set_process_input(true)


## While pressed we listen globally so the drag keeps working after the
## pointer leaves the collision shape.
func _input(event: InputEvent) -> void:
	if not _pressed:
		return
	if event is InputEventMouseMotion:
		_drag_accum += absf(event.relative.x)
		if _spin_target and _drag_accum > DRAG_THRESHOLD:
			_spin_target.rotate_y(event.relative.x * SPIN_RADIANS_PER_PX)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		_pressed = false
		set_process_input(false)
		if _drag_accum <= DRAG_THRESHOLD:
			if external_url != "":
				OS.shell_open(external_url)
			anchor_clicked.emit(anchor_id)


func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	_set_highlight(true)


func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	_set_highlight(false)


func _set_highlight(on: bool) -> void:
	for mesh in find_children("*", "MeshInstance3D", true, false):
		mesh.material_overlay = HOVER_OVERLAY if on else null
