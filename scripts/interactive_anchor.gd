extends Area3D
## Clickable 3D element ("interactive anchor" in the technical brief).
## Emits anchor_clicked so the UI overlay can react; optionally opens an
## external URL directly (social profiles, external pages).

signal anchor_clicked(anchor_id: String)

const HOVER_OVERLAY := preload("res://materials/hover_overlay.tres")

@export var anchor_id: String = "anchor"
@export var external_url: String = ""


func _ready() -> void:
	add_to_group("interactive_anchors")
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
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
