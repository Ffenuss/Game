# Следующий этап разработки

This roadmap now starts from the current state of the repository after the production bible and chapter design work. The next highest-impact milestone is the visual rescue pass that makes the first screenshot read like a real game.

## 1. Immediate next milestone

**M1. Visual rescue pass**

This milestone is intentionally narrow: it does not add new gameplay systems. It fixes the visible composition so the current slice stops reading as a debug room.

## 2. Why this milestone comes first

- The game loop is already playable.
- The next screenshot is still the clearest proof of quality for this slice.
- The current visual composition is the main thing making the project feel unfinished.
- The screenshot must improve before export prep and device QA can be judged fairly.
- This work has low systemic risk and very high visible impact.

## 3. Tasks for this milestone

- Expand and reframe the first location so it fills the screen more naturally.
- Move the player camera view away from the prototype-room feel.
- Compact and separate the HUD so it no longer sits in the central play area.
- Strengthen the dark-fantasy backdrop and framing.
- Keep the scene readable on Android while preserving the existing loop.

## 4. Files likely to change

- `data/locations/collapsed_bridge.json`
- `scenes/main/main.tscn`
- `scenes/ui/mobile_hud.tscn`
- `scripts/ui/mobile_hud.gd`
- `scripts/world/location_scene.gd`
- `docs/RELEASE_AUDIT.md`
- `docs/CHANGELOG.md`
- `docs/BLOCKERS.md`
- `PLANS.md`

## 5. Done criteria

- The first screenshot no longer reads as a gray debug room.
- The HUD no longer covers the center of gameplay.
- The first location feels more like an intentional chapter opening.
- The current playable loop still works after the visual pass.
- No forbidden assets or engine features are introduced.

## 6. Validation plan

- Run `git diff --check`.
- Run `tools/validate_project_structure.gd`.
- Run `tools/validate_asset_manifest.gd` if asset references change.
- Run `tools/validate_runtime_smoke.gd` if the scenes/scripts still parse.
- Review the updated HUD and location layout in the Godot Editor or Android preview.
- If Android device QA is not available, record the limitation honestly and provide manual test steps.

## 7. Next milestones after this one

1. Android export preset and release engineering prep.
2. Android device-side screenshot and control QA.
3. Save/checkpoint verification on device.
4. Combat feel tuning and failure-state polish.
5. Lightweight audio feedback pass if safe CC0 assets or generated SFX are available.
