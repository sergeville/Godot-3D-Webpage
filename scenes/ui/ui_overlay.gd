extends CanvasLayer
## UI overlay: Control nodes anchored as a top layer over the 3D view.
## Holds the project catalog — each pedestal's anchor_id keys into PROJECTS.

const PROJECTS := {
	"workspace_hub": {
		"title": "workspace-hub",
		"desc": "A local-first project control center for managing, launching, and monitoring a workspace full of local services, dashboards, and projects. JavaScript.",
		"url": "https://github.com/sergeville/workspace-hub",
	},
	"yca": {
		"title": "YouTube Comments Analyzer",
		"desc": "Extracts YouTube comments, classifies them, generates a static HTML view, and imports the results into a Neo4j graph.",
		"url": "https://github.com/sergeville/youtube-comments-analyzer",
	},
	"maverick": {
		"title": "Maverick Command Core",
		"desc": "A high-fidelity, high-contrast automotive diagnostic suite for the Ford Maverick. Next.js 15, Tailwind CSS, and Web Bluetooth LE.",
		"url": "https://github.com/sergeville/maverick-command-core",
	},
	"momrecette": {
		"title": "MomRecette",
		"desc": "iOS / iPadOS / macOS app for keeping and browsing family recipes. Swift.",
		"url": "https://github.com/sergeville/MomRecette",
	},
	"godot_site": {
		"title": "This Site",
		"desc": "The site you are looking at — built in Godot 4, exported to WebAssembly, and deployed to GitHub Pages by a GitHub Actions workflow.",
		"url": "https://github.com/sergeville/Godot-3D-Webpage",
	},
	"hvac_buddy": {
		"title": "HVAC Buddy",
		"desc": "Welcome to my portfolio! I'm the site mascot, left over from this project's HVAC-demo days. Click a pedestal to explore a project — each one opens on GitHub.",
		"url": "",
	},
}

@onready var info_panel: PanelContainer = $Root/InfoPanel
@onready var title_label: Label = $Root/InfoPanel/Margin/Column/TitleLabel
@onready var info_label: Label = $Root/InfoPanel/Margin/Column/InfoLabel
@onready var github_button: Button = $Root/InfoPanel/Margin/Column/Buttons/GitHubButton
@onready var close_button: Button = $Root/InfoPanel/Margin/Column/Buttons/CloseButton

var _current_url := ""


func _ready() -> void:
	close_button.pressed.connect(info_panel.hide)
	github_button.pressed.connect(_open_github)
	info_panel.hide()


func show_panel(anchor_id: String) -> void:
	var project: Dictionary = PROJECTS.get(anchor_id, {})
	title_label.text = project.get("title", anchor_id)
	info_label.text = project.get("desc", "")
	_current_url = project.get("url", "")
	github_button.visible = _current_url != ""
	info_panel.show()


func _open_github() -> void:
	if _current_url != "":
		OS.shell_open(_current_url)
