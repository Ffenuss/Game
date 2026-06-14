# Plans

## Current Phase

Visual polish pass: make the current Android slice read as a game instead of a debug prototype by shrinking and framing the HUD, darkening the empty screen space, and improving camera composition and level atmosphere.

## Current Diagnosis

- Working: the core playable loop, title flow, movement, combat, dialogue, quest scaffolds, checkpointing, save support, and existing data-driven world structure.
- Incomplete: visual framing, HUD compactness, asset polish, Android screenshot QA, and export prep.
- Broken or risky: the HUD still reads like a development overlay, the empty background space makes the world feel small, and the player camera currently reveals too much dead space for the current map size.
- Planned improvement: add a dark full-screen backdrop, compact the HUD into lower-screen thumb zones, make the bars and buttons more game-like, and give the first location stronger visual framing without changing gameplay scope.

## Completed Steps

- Confirmed the repository was empty.
- Confirmed Git was available but the repo was not initialized.
- Confirmed internet access was available.
- Confirmed `godot` / `godot4` were not available on the PATH.
- Confirmed core shell utilities were available.
- Initialized Git and created branch `codex/bootstrap-rpg`.
- Created repository instructions, architecture docs, asset policy docs, art/world bibles, roadmap, Android testing notes, decisions, changelog, replacement guide, blockers, and environment report.
- Added `project.godot`, autoload stubs, input actions, and the main scene bootstrap settings.
- Added procedural placeholder generators, normalized runtime placeholder assets, and the asset manifest.
- Imported a small CC0 Kenney UI scaffold and archived its license proof.
- Added data-driven location, dialogue, quest, item, and enemy JSON content for the initial vertical slice.
- Added player, enemy, NPC, HUD, dialogue, inventory, journal, pause, quest-toast, and title-screen scene shells.
- Added modular gameplay scripts for state, save, asset resolution, quest flow, player movement, enemies, combat, interaction, checkpointing, and location routing.
- Added validation scripts and the Android manual test checklist.
- Verified the project structure, manifest, and headless startup smoke under Godot 4.6.3 ARM64.
- Refined the mobile HUD for smaller touch targets and better landscape anchoring.
- Tightened the mobile HUD again after screenshot review so the action cluster sits deeper in the lower-right thumb zone and the status panel is less dominant.
- Softened the HUD chrome and reduced caption font size so the controls read less like debug widgets and more like a game UI.
- Updated the journal to show the quest title instead of only the raw quest ID.
- Recorded the current release-prep environment state and release audit gaps.
- Reworked the visual polish pass to target backdrop framing, camera composition, and more readable mobile UI surfaces.

## Next Safe Steps

1. Open the project in the Android Editor and verify the new HUD, backdrop, and camera composition on a device-sized viewport.
2. Capture screenshots to confirm the gameplay area no longer reads as a gray debug room.
3. If the device review is acceptable, commit the visual polish checkpoint and stop before broader gameplay work.

## Blockers

- No code blocker is currently confirmed.
- Android Editor and device-side screenshot QA are still required for visual confidence.
- Android export setup still needs verification in a later pass.

## Validation Results

- Repository and environment inspection completed.
- Network reachability verified.
- Git repository initialized.
- Static file creation and data wiring completed.
- Headless validation passed with `/tmp/godot-4.6.3-arm64/Godot_v4.6.3-stable_linux.arm64`.
- `tools/validate_project_structure.gd` passed.
- `tools/validate_asset_manifest.gd` passed.
- `tools/validate_runtime_smoke.gd` passed and started `res://scenes/main/title_screen.tscn`.
- Current release-prep revalidation also passed after the HUD and journal edits:
  - `validate_project_structure.gd` exit `0`
  - `validate_asset_manifest.gd` exit `0`
  - `validate_runtime_smoke.gd` exit `0`
- Procedural UI assets were regenerated successfully with `tools/generate_placeholder_assets.gd`.
- Current visual-pass revalidation also passed after the backdrop, HUD, and asset updates:
  - `validate_project_structure.gd` exit `0`
  - `validate_asset_manifest.gd` exit `0`
  - `validate_runtime_smoke.gd` exit `0`

## Manual Android Testing Requests

1. Run the project in Godot 4.6 Android Editor.
2. Confirm landscape orientation and Compatibility renderer.
3. Confirm the HUD buttons stay in the lower-right thumb zone.
4. Confirm the joystick is smaller and less visually dominant.
5. Confirm the world no longer reads as a gray debug room.
6. Capture screenshots and logs for layout and readability review.

## Unresolved Questions

- None blocking at bootstrap time.

## Files Changed in Current Phase

- Root config: `project.godot`, `.gitignore`, `AGENTS.md`, `PLANS.md`, `README.md`
- Docs: `docs/*.md` including architecture, asset policy, art bible, world bible, roadmap, Android testing, decisions, changelog, replacement guide, environment report, blockers, asset requests, and release audit notes
- Scripts: `scripts/autoload/`, `scripts/core/`, `scripts/player/`, `scripts/enemies/`, `scripts/npc/`, `scripts/combat/`, `scripts/dialogue/`, `scripts/quests/`, `scripts/ui/`, `scripts/world/`, `scripts/effects/`
- Scenes: `scenes/boot/`, `scenes/main/`, `scenes/player/`, `scenes/enemies/`, `scenes/npc/`, `scenes/ui/`, `scenes/locations/`
- Data: `data/assets/`, `data/dialogues/`, `data/enemies/`, `data/items/`, `data/quests/`, `data/locations/`
- Assets: `assets/generated/placeholders/`, `assets/runtime/`
- Third-party: `third_party/assets/kenney-pixel-ui-pack/`, `credits/THIRD_PARTY_ASSETS.md`
- Validation support: `tools/`, `tests/`
