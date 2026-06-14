# Пепельный Дол: Клеймо Пустоши

Android-first Godot 4.6 pixel-art action RPG vertical slice.

## What this repo is

An original dark-fantasy mobile RPG slice built for the Godot 4 Android Editor workflow.
The goal is a small playable core: title screen, movement, touch controls, one test area, combat, checkpointing, dialogue, and a quest scaffold.

## Canonical development docs

Before editing, future contributors must read:

- [docs/GAME_DEV_BIBLE.md](docs/GAME_DEV_BIBLE.md)
- [docs/ASSET_SOURCES_2026.md](docs/ASSET_SOURCES_2026.md)
- [docs/LICENSE_POLICY.md](docs/LICENSE_POLICY.md)
- [docs/GODOT_46_PROJECT_RULES.md](docs/GODOT_46_PROJECT_RULES.md)
- [docs/ANDROID_GAME_RULES.md](docs/ANDROID_GAME_RULES.md)
- [docs/CODEX_WORKFLOW.md](docs/CODEX_WORKFLOW.md)
- [PLANS.md](PLANS.md)

## Constraints

- Godot 4.6
- GDScript only
- Compatibility renderer
- Landscape orientation
- TileMapLayer for maps
- Local saves only
- No native plugins, Mono, or online services

These constraints are expanded in [docs/GAME_DEV_BIBLE.md](docs/GAME_DEV_BIBLE.md) and the supporting rulebooks.

## How to open

1. Open the project folder in Godot 4.6.
2. Ensure the project runs with the Compatibility renderer.
3. Open `project.godot` if needed and confirm the main scene is `res://scenes/boot/boot.tscn`.

## How to run

- Use the main scene flow through the boot scene.
- The playable slice is assembled from `scenes/main/main.tscn` and the location scenes under `scenes/locations/`.

## Repository structure

- `docs/` for architecture, policy, decisions, and environment notes.
- `assets/generated/placeholders/` for procedural source placeholders.
- `assets/runtime/` for canonical runtime assets used by scenes and scripts.
- `resources/` for reusable resource templates that future phases can fill in.
- `data/` for JSON content: assets, dialogue, quests, enemies, and locations.
- `scenes/` for reusable Godot scenes.
- `scripts/` for modular GDScript systems.
- `credits/` for third-party attribution and license records.
- `third_party/` for archived source assets and proof files.
- `tools/` for generation and validation helpers.

## Placeholders and normalization

Procedural assets are generated from stable source paths under `assets/generated/placeholders/`, then normalized into `assets/runtime/`.
Third-party CC0 scaffolding assets, when used, are stored in `third_party/assets/` and normalized into `assets/runtime/`.

## Adding or replacing an asset

1. Update or add the source asset.
2. Normalize it into `assets/runtime/`.
3. Update `data/assets/asset_manifest.json`.
4. Update [docs/ASSET_REPLACEMENT_GUIDE.md](docs/ASSET_REPLACEMENT_GUIDE.md) if dimensions or regions change.
5. Update [credits/THIRD_PARTY_ASSETS.md](credits/THIRD_PARTY_ASSETS.md) for any imported third-party file.

## Android testing

See [docs/ANDROID_TESTING.md](docs/ANDROID_TESTING.md) for the manual device checklist.

## Current scope

The repository is being bootstrapped into a small vertical slice with:

- title screen
- player movement
- touch HUD
- basic melee combat
- one checkpoint
- one NPC
- one quest scaffold
- local save support

## Known limitations

- No permanent Godot binary is bundled with the repository.
- Visual correctness still needs in-editor and Android device verification.
- Headless startup smoke passed in this environment with a temporary ARM64 Godot 4.6.3 binary.
