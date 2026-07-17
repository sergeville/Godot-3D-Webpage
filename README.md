# Godot 4 3D Webpage

Interactive 3D webpage (portfolio-style site) built in Godot 4, exported to WebAssembly for the browser.

**Start here:** [docs/TECHNICAL_BRIEF.md](docs/TECHNICAL_BRIEF.md) — the implementation contract. Renderer mode, scene architecture, browser interop, and export settings are all fixed there.

## Status

Brief written 2026-07-17. Godot project not yet created.

## Key constraints (from the brief)

- Compatibility renderer (WebGL 2.0), not Forward+
- Thread support OFF in the web export (no SharedArrayBuffer headers needed)
- Baked lightmaps, no real-time shadows
- Must be served over HTTP — `file://` won't run WebAssembly

## Tracking

- Archon: project `78113f0a-9a33-4307-9cc9-c4d89d63345f` — "Godot 4 3D Webpage" (http://127.0.0.1:8181)
- Linear: [Godot 4 3D Webpage](https://linear.app/movetolinear/project/godot-4-3d-webpage-d8dddec74516) (MoveToLinear team)
- First task: Archon `8aeee5eb` ↔ [MOV-166](https://linear.app/movetolinear/issue/MOV-166/set-up-godot-4-project-per-technical-brief) — set up the Godot project per the brief
