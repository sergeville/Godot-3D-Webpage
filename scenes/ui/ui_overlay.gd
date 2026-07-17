extends CanvasLayer
## UI overlay: Control nodes anchored as a top layer over the 3D view.
## Menus, contact forms, and textual information live here — never on
## 3D surfaces.

const DESCRIPTIONS := {
	"condenser": "Condenser unit — outdoor coil, compressor, and that spinning fan on top.",
	"thermostat": "Thermostat — the control point for the whole system.",
	"hvac_buddy": "HVAC Buddy — your guide around the mechanical room.",
}

@onready var info_panel: PanelContainer = $Root/InfoPanel
@onready var info_label: Label = $Root/InfoPanel/Margin/Column/InfoLabel
@onready var close_button: Button = $Root/InfoPanel/Margin/Column/CloseButton


func _ready() -> void:
	close_button.pressed.connect(info_panel.hide)
	info_panel.hide()


func show_panel(anchor_id: String) -> void:
	info_label.text = DESCRIPTIONS.get(anchor_id, "You clicked: %s" % anchor_id)
	info_panel.show()
