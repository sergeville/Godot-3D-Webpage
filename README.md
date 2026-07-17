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

- Archon: project "Godot 4 3D Webpage" (http://127.0.0.1:8181)
- Linear: MoveToLinear team
