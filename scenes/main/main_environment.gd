extends Node3D
## Main environment: wires interactive anchors to the UI overlay.

@onready var ui_overlay: CanvasLayer = $UiOverlay


func _ready() -> void:
	for anchor in get_tree().get_nodes_in_group("interactive_anchors"):
		anchor.anchor_clicked.connect(ui_overlay.show_panel)
