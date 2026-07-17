extends Node3D
## Main environment: wires interactive anchors to the UI overlay and owns
## blueprint mode (dreiraum-inspired): B key or chip swaps every mesh to a
## shared translucent blueprint material, hides the fake contact shadows,
## and reveals engineering callouts.

const BLUEPRINT_MAT := preload("res://materials/blueprint.tres")

@onready var ui_overlay: CanvasLayer = $UiOverlay
@onready var world_env: WorldEnvironment = $WorldEnvironment
@onready var callouts: Node3D = $BlueprintCallouts

var _blueprint_on := false
var _normal_env: Environment
var _blueprint_env: Environment


func _ready() -> void:
	for anchor in get_tree().get_nodes_in_group("interactive_anchors"):
		anchor.anchor_clicked.connect(ui_overlay.show_panel)
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
