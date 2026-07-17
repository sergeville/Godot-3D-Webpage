# Technical Project Brief: Godot 4 3D Webpage
*Created: 2026-07-17*

## Purpose

Build an interactive 3D webpage (portfolio-style site) in Godot 4, exported to WebAssembly and served in the browser. This brief is the implementation contract for the agent doing the build: renderer, scene architecture, browser interop, and export settings are all fixed below — don't deviate without flagging it.

---

## 1. Core Project Configuration

Configure the project for browser distribution first, before any content work. The goal is minimal load time and zero rendering surprises across browsers.

- **Renderer:** Force **Compatibility mode** — not Forward+ or Mobile. Compatibility targets WebGL 2.0, which is what actually works in browsers today.
- **Window settings:** Project Settings → Display → Window → set Stretch **Mode** to `canvas_items` and **Aspect** to `expand`. This gives a responsive layout that fills any browser viewport.
- **Optimization:** Disable every engine module the project doesn't use (e.g. 3D physics if you only need visual raycasting). Every disabled module shrinks the final `.wasm` package.

## 2. Architecture & Scene Breakdown

Split the site into small scenes in organized `snake_case` folders.

- **Loading screen (boot scene):** A lightweight 2D scene that loads first and gives immediate visual feedback while the heavier 3D content streams in. Never let the user stare at a blank canvas.
- **Main environment (3D scene):** `Node3D` root containing the main view.
  - `Camera3D` with restricted movement limits to prevent clipping through geometry.
  - `WorldEnvironment` with low-overhead lighting — baked lightmaps, not real-time shadows. Real-time shadow passes are the fastest way to tank browser framerates.
- **Interactive anchors:** `Area3D` nodes with collision shapes act as clickable 3D elements — e.g. clicking a 3D model opens the portfolio menu.
- **UI overlay:** `Control` nodes anchored as a top layer for menus, contact forms, and text. Keep all text in the 2D UI layer, not on 3D surfaces.

## 3. Web Navigation & Browser Interoperability

Godot talks to the hosting browser through two mechanisms:

- **External linking:** `OS.shell_open("url")` for simple redirects — social profiles, external pages.
- **JavaScript bridge:** the `JavaScriptBridge` singleton for direct interaction with the page — browser-native alerts, passing data to the parent HTML frame:

```gdscript
if JavaScriptBridge.has_feature("live"):
    JavaScriptBridge.eval("console.log('Godot 3D site successfully loaded!')")
```

Always guard `JavaScriptBridge` calls with `has_feature("live")` so the project still runs in the editor and native builds.

## 4. Export & Deployment Requirements

- **Export preset:** Web platform preset.
- **Thread support: OFF** unless the project genuinely needs background computation. Enabling it requires `SharedArrayBuffer`, which demands COOP/COEP server headers that break on basic static hosting.
- **Output files:** The build must produce `index.html` plus the associated `.wasm`, `.js`, and `.pck` packages. All four ship together.
- **Hosting:** Serve from a real web server — local dev server, GitHub Pages, Vercel, or Itch.io. WebAssembly security policy blocks launching from a `file://` path, so "just open index.html" will never work.

---

## References

1. [Godot web export walkthrough (YouTube)](https://www.youtube.com/watch?v=WWzX55Jhz2U&t=7)
2. [Tarmac — Create web 3D experiences with Godot](https://www.tarmac.io/resources/create-web-3d-experiences-with-godot-its-open-source)
3. [r/godot — Godot 4 for web games discussion](https://www.reddit.com/r/godot/comments/1mqaqwn/is_godot_4_absolutely_not_desirable_for_web_games/)
4. [Kodeco — Making responsive UI in Godot](https://www.kodeco.com/45869762-making-responsive-ui-in-godot)
5. [Godot project organization (YouTube)](https://www.youtube.com/watch?v=I8n8qd9tA5Y&t=66)
6. [Snopek Games — WebXR with Godot 4](https://www.snopekgames.com/tutorial/2023/how-make-vr-game-webxr-godot-4/)
7. [Sopra Steria — AR on the web (three.js/WebXR)](https://medium.com/sopra-steria-norge/get-started-with-augmented-reality-on-the-web-using-three-js-and-webxr-part-1-8b07757fc23a)
8. [r/godot — Godot meets web development](https://www.reddit.com/r/godot/comments/ijx0cg/godot_meets_web_development/)
9. [Godot web export settings (YouTube)](https://www.youtube.com/watch?v=zp2P29Xa798&t=5)
10. [Godot web deployment & thread support (YouTube)](https://www.youtube.com/watch?v=TgLxdEA6f04&t=259)
11. [Godot local hosting for web builds (YouTube)](https://www.youtube.com/watch?v=_WcDN9p-O54)
