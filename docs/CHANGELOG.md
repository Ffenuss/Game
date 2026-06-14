# Changelog

## Unreleased

- Added the permanent game development bible and supporting rulebooks for Codex, Android, licensing, and asset sourcing.
- Initialized the Android-first Godot repository structure.
- Added architecture, policy, art, world, roadmap, testing, and decision docs.
- Added bootstrap planning and environment reporting files.
- Added procedural placeholder atlases and runtime placeholder copies for tiles, player, enemies, UI, items, effects, props, and NPC scaffolding.
- Added a normalized CC0 UI scaffold import from Kenney Pixel UI Pack.
- Added the asset manifest, asset catalog, and replacement documentation.
- Added data-driven location, dialogue, enemy, item, and quest JSON files for the initial vertical slice.
- Added scene shells for boot, title screen, main root, player, enemies, NPC, touch HUD, modal UI, and layered location maps.
- Added modular combat, checkpoint, dialogue, quest, save, and scene-router scripts.
- Added the first playable slice foundation for `Пепельный Дол: Клеймо Пустоши`.
- Verified the repository with Godot 4.6.3 ARM64 headless structure, manifest, and startup smoke checks.
- Added a PNG-friendly runtime asset fallback path in `AssetCatalog` for headless validation environments.
- Compactified the mobile HUD layout for better landscape readability on phones.
- Tightened the mobile HUD again after screenshot review so the action cluster sits deeper in the lower-right thumb zone and the status panel is less dominant.
- Updated the journal to show the quest title instead of only the raw quest ID.
- Added a release audit and Android release notes for the current vertical slice.
- Started a visual polish pass to add darker framing, a smaller joystick, compact lower-right action buttons, and a more game-like HUD presentation.
- Regenerated the procedural UI atlas and added a full-screen vignette backdrop asset for mobile framing.
