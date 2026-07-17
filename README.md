# Godot 3D Webpage — Project Portfolio

**Live site: https://sergeville.github.io/Godot-3D-Webpage/**

An interactive 3D portfolio built in Godot 4 and exported to WebAssembly. Five pedestals showcase my public GitHub projects — click one and an info panel opens with a **View on GitHub** button. HVAC Buddy, the site mascot, guides visitors; the condenser unit and duct run in the background are set dressing left over from the project's HVAC-demo days.

Built for the browser from the ground up: Compatibility renderer (WebGL 2.0), no real-time shadows (fake contact shadows instead), thread support off so it runs on any static host, and a 2D boot screen that streams the 3D scene in.

## Projects on display

| Pedestal | Project |
|---|---|
| Teal cube | [workspace-hub](https://github.com/sergeville/workspace-hub) — local-first project control center |
| Red cylinder | [youtube-comments-analyzer](https://github.com/sergeville/youtube-comments-analyzer) — YouTube comments → Neo4j |
| Orange prism | [maverick-command-core](https://github.com/sergeville/maverick-command-core) — Ford Maverick diagnostic suite |
| Rose sphere | [MomRecette](https://github.com/sergeville/MomRecette) — family recipes app (Swift) |
| Blue ring | [Godot-3D-Webpage](https://github.com/sergeville/Godot-3D-Webpage) — this site |

## Installation — step by step

### 1. Install Godot 4.7

macOS (Homebrew):

```bash
brew install godot
godot --version   # expect 4.7.stable
```

Or download the editor for your platform from https://godotengine.org/download (this project targets **4.7 stable**).

### 2. Clone the repository

```bash
git clone https://github.com/sergeville/Godot-3D-Webpage.git
cd Godot-3D-Webpage
```

### 3. Import the project

Open it once so Godot generates its import cache (`.godot/`):

```bash
godot --headless --path . --import
```

Or open the Godot editor, click **Import**, and select this folder's `project.godot`.

### 4. Run it locally (editor)

```bash
godot --path .
```

Press **F5** in the editor to run. The boot scene loads first, then streams in the portfolio.

### 5. Install web export templates (one-time)

Exports need the official template bundle matching your Godot version (~1.2 GB, all platforms):

```bash
curl -L -o /tmp/godot_templates.tpz \
  https://github.com/godotengine/godot/releases/download/4.7-stable/Godot_v4.7-stable_export_templates.tpz
unzip /tmp/godot_templates.tpz -d /tmp/godot_templates
mkdir -p ~/Library/Application\ Support/Godot/export_templates/4.7.stable
mv /tmp/godot_templates/templates/* ~/Library/Application\ Support/Godot/export_templates/4.7.stable/
```

On Linux the destination is `~/.local/share/godot/export_templates/4.7.stable/` instead. Alternatively, in the editor: **Editor → Manage Export Templates → Download and Install**.

### 6. Export the web build

```bash
mkdir -p build/web
godot --headless --path . --export-release "Web" build/web/index.html
```

This produces `index.html`, `index.js`, `index.pck`, and `index.wasm` (~38 MB) in `build/web/`.

### 7. Serve it over HTTP

WebAssembly will not run from a `file://` path — always use a web server:

```bash
cd build/web
python3 -m http.server 8060
```

Then open http://localhost:8060 in a browser.

### 8. Deploy (automatic)

Every push to `main` triggers [.github/workflows/deploy.yml](.github/workflows/deploy.yml): it builds the web export with headless Godot in CI (binary and templates cached between runs) and publishes `build/web/` to GitHub Pages. No manual steps — `build/` is gitignored and never committed.

To set this up on a fork: **Settings → Pages → Source: GitHub Actions**, then push to `main`.

## Project structure

```
project.godot                  Compatibility renderer, canvas_items/expand stretch
export_presets.cfg             Web preset — thread support OFF
scenes/
  boot/boot_screen.tscn        2D loading screen, threaded load of the main scene
  main/main_environment.tscn   Portfolio room: pedestals, lights, set dressing
  ui/ui_overlay.tscn           Title, hint, project info panel (+ project catalog in ui_overlay.gd)
scripts/
  interactive_anchor.gd        Clickable Area3D: hover highlight + anchor_clicked signal
  idle_motion.gd               Cheap bob/spin idle animation (no AnimationPlayer)
  web_bridge.gd                JavaScriptBridge autoload, guarded by OS.has_feature("web")
materials/hover_overlay.tres   Shared hover-highlight overlay material
docs/TECHNICAL_BRIEF.md        Original implementation contract
```

## Adding a project pedestal

1. Add an entry to `PROJECTS` in [scenes/ui/ui_overlay.gd](scenes/ui/ui_overlay.gd) (key, title, desc, url).
2. In [scenes/main/main_environment.tscn](scenes/main/main_environment.tscn), duplicate a `Pedestal*` node, set its `anchor_id` to the new key, and give its `Item` a distinct mesh/color and its `Label3D` the project name.
3. Export and push — the workflow deploys it.

## Tracking

- Archon project `78113f0a-9a33-4307-9cc9-c4d89d63345f` (http://127.0.0.1:8181)
- Linear: [Godot 4 3D Webpage](https://linear.app/movetolinear/project/godot-4-3d-webpage-d8dddec74516) (MoveToLinear team)
