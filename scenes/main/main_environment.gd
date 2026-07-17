extends Node3D
## Main environment: wires interactive anchors to the UI overlay and owns
## blueprint mode (dreiraum-inspired): B key or chip swaps every mesh to a
## shared translucent blueprint material, hides the fake contact shadows,
## and reveals engineering callouts.

const BLUEPRINT_MAT := preload("res://materials/blueprint.tres")
const FLY_DURATION := 0.8

@onready var ui_overlay: CanvasLayer = $UiOverlay
@onready var world_env: WorldEnvironment = $WorldEnvironment
@onready var callouts: Node3D = $BlueprintCallouts
@onready var camera: Camera3D = $Camera3D

var _blueprint_on := false
var _normal_env: Environment
var _blueprint_env: Environment
var _home_cam: Transform3D
var _cam_tween: Tween


func _ready() -> void:
	_home_cam = camera.transform
	for anchor in get_tree().get_nodes_in_group("interactive_anchors"):
		anchor.anchor_clicked.connect(ui_overlay.show_panel)
		anchor.anchor_clicked.connect(_fly_to.bind(anchor))
	ui_overlay.panel_closed.connect(_fly_home)
	_normal_env = world_env.environment
	_blueprint_env = Environment.new()
	_blueprint_env.background_mode = Environment.BG_COLOR
	_blueprint_env.background_color = Color(0.02, 0.05, 0.11)
	_blueprint_env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	_blueprint_env.ambient_light_color = Color(1, 1, 1)
	_blueprint_env.ambient_light_energy = 1.0
	ui_overlay.blueprint_toggled.connect(_set_blueprint)
	ui_overlay.motion_toggled.connect(_set_motion)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_B:
		ui_overlay.sync_blueprint_chip(not _blueprint_on)
		_set_blueprint(not _blueprint_on)


func _set_blueprint(on: bool) -> void:
	_blueprint_on = on
	world_env.environment = _blueprint_env if on else _normal_env
	callouts.visible = on
	for mesh in find_children("*", "MeshInstance3D", true, false):
		if mesh.is_in_group("contact_shadows"):
			mesh.visible = not on
		else:
			mesh.material_override = BLUEPRINT_MAT if on else null


func _set_motion(on: bool) -> void:
	for node in get_tree().get_nodes_in_group("idle_motion"):
		node.set_process(on)


## Tween the camera in to frame the clicked anchor's item. The look target
## is nudged right so the object settles in the left half of the frame,
## leaving room for the info panel docked on the right edge.
func _fly_to(_anchor_id: String, anchor: Node3D) -> void:
	var focus := anchor.global_position + Vector3(0, 1.15, 0)
	var cam_pos := focus + Vector3(0.9, 0.35, 2.6)
	var look_target := focus + Vector3(0.55, 0, 0)
	_tween_camera(Transform3D(Basis.looking_at(look_target - cam_pos), cam_pos))


func _fly_home() -> void:
	_tween_camera(_home_cam)


func _tween_camera(target: Transform3D) -> void:
	if _cam_tween:
		_cam_tween.kill()
	_cam_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	_cam_tween.tween_property(camera, "transform", target, FLY_DURATION)
