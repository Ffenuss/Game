# Plans

## Current Phase

Current-state audit completed; M1 visual rescue pass is in progress; the immediate goal is to make the first chapter screenshot read like a real game instead of a gray prototype. The current pass now includes a generated dark world backdrop, a corrected player spawn path, and a stronger HUD/camera composition.

## Current Diagnosis

- Working: the repository already has a playable Android-first Godot vertical slice, modular code, an asset pipeline, and a strong documentation base.
- Incomplete: the project still lacks a committed Android export preset and device-side QA has not been completed in this turn.
- Broken or risky: the slice is playable but still needs real-device verification for HUD spacing, export flow, and final screenshot readability.
- Planned improvement: finish the visual rescue pass by expanding and reframing the first location and tightening the HUD, then move to export prep.
- Current focus: the first location, dark framing, and HUD composition are being updated so the screen no longer looks like a test room.
- Status after the previous documentation phase: the permanent documentation set exists and future tasks are pointed at the correct canonical rules.

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
- Fixed the player spawn path in the location scene so the player actually instantiates again.
- Generated and wired a full-screen dark world backdrop asset to replace the gray prototype margins.
- Increased camera zoom slightly so the first location reads larger on the screen.
- Updated the journal to show the quest title instead of only the raw quest ID.
- Recorded the current release-prep environment state and release audit gaps.
- Reworked the visual polish pass to target backdrop framing, camera composition, and more readable mobile UI surfaces.
- Identified the need for a permanent documentation bible and supporting rulebooks before any further gameplay or asset changes.
- Created the permanent game development bible and supporting rulebooks for asset sources, licensing, Godot 4.6 rules, Android rules, visual style, Codex workflow, production checklists, and source update policy.
- Updated `AGENTS.md` so future Codex tasks must read the new canonical docs first.
- Updated existing docs and README cross-links so the new documentation hierarchy is explicit.
- Inspected the actual repository state again for the current release-readiness audit.
- Confirmed the main scene, title flow, player, HUD, world, combat, checkpoint, save, dialogue, quest, inventory, journal, and asset pipeline are all present in the current tree.
- Confirmed the project still has no committed `export_presets.cfg`.
- Confirmed a temporary headless Godot 4.6.3 binary is available under `/tmp/godot-4.6.3-arm64/`.
- Created `docs/CURRENT_PROJECT_STATUS.md` and `docs/NEXT_DEVELOPMENT_PLAN.md` to make the current readiness and next milestone explicit.
- Created `docs/FULL_GAME_PRODUCTION_PLAN.md` and `docs/CHAPTER_1_DESIGN.md` to define the first chapter and the longer production path.

## Next Safe Steps

1. Finish the M1 visual rescue pass and record the exact results.
2. Move to Android export prep with a committed `export_presets.cfg`.
3. Run Android device-side screenshot and control QA once export prep is in place.

## Blockers

- No code blocker is currently confirmed.
- Android Editor and device-side screenshot QA remain required for the current slice.
- Android export setup still needs verification in a later pass.
- The repository does not yet have a committed Android export preset.
- No asset import or gameplay work was performed in the documentation-focused phase.
- The current visual rescue pass is still being validated after the location/HUD adjustments.

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
- The shared UI helper and compact HUD pass were validated with headless Godot:
  - `validate_project_structure.gd` exit `0`
  - `validate_asset_manifest.gd` exit `0`
  - `validate_runtime_smoke.gd` exit `0`
- Documentation-only pass: no runtime validation is required beyond static repository checks unless a file change touches scenes, scripts, or assets.
- `git diff --check` passed after the documentation updates.
- `git diff --check` exit `0` after the final documentation and plan updates.
- `validate_project_structure.gd` exit `0` after the documentation updates.
- `validate_asset_manifest.gd` exit `0` after the documentation updates.
- `validate_runtime_smoke.gd` exit `0` and started `res://scenes/main/title_screen.tscn`.
- Repository inspection for the current audit completed:
  - `git status --short --branch`
  - `find scenes`, `find scripts`, `find data`, `find resources`, `find tools`
  - inspected `project.godot`, main/title/player/HUD scenes, core scripts, location data, asset manifest, and export preset presence
- JSON layout sanity checks were run on `data/locations/collapsed_bridge.json` to verify row lengths after the visual rescue changes.
- Current rescue-pass validation also passed:
  - `git diff --check` exit `0`
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
7. For the documentation pass, verify the new bible links and future-agent instructions only.
8. For future work, ensure each task still starts with the canonical docs sequence.
9. For the current release pass, verify the UI/presentation improvement on the next screenshot.

## Unresolved Questions

- None blocking for the current audit/presentation pass.

## Files Changed in Current Phase

- Root config: `project.godot`, `.gitignore`, `AGENTS.md`, `PLANS.md`, `README.md`
- Docs: `docs/*.md` including architecture, asset policy, art bible, world bible, roadmap, Android testing, decisions, changelog, replacement guide, environment report, blockers, asset requests, release audit notes, plus the new game bible, source policy, license policy, Godot rules, Android rules, visual style, Codex workflow, production checklists, and source update policy
- Docs: `docs/*.md` including architecture, asset policy, art bible, world bible, roadmap, Android testing, decisions, changelog, replacement guide, environment report, blockers, asset requests, release audit notes, plus the new game bible, source policy, license policy, Godot rules, Android rules, visual style, Codex workflow, production checklists, source update policy, current project status, and next development plan
- Current rescue-pass files: `assets/generated/placeholders/environment/world_backdrop_mist.png`, `assets/runtime/environment/world_backdrop_mist.png`, `data/assets/asset_manifest.json`, `data/locations/collapsed_bridge.json`, `scenes/main/main.tscn`, `scenes/ui/mobile_hud.tscn`, `scripts/player/player.gd`, `scripts/ui/mobile_hud.gd`, `scripts/world/location_scene.gd`, `tools/generate_placeholder_assets.gd`, `docs/CHANGELOG.md`, `docs/ASSET_REPLACEMENT_GUIDE.md`
- Scripts: `scripts/autoload/`, `scripts/core/`, `scripts/player/`, `scripts/enemies/`, `scripts/npc/`, `scripts/combat/`, `scripts/dialogue/`, `scripts/quests/`, `scripts/ui/`, `scripts/world/`, `scripts/effects/`
- Scenes: `scenes/boot/`, `scenes/main/`, `scenes/player/`, `scenes/enemies/`, `scenes/npc/`, `scenes/ui/`, `scenes/locations/`
- Data: `data/assets/`, `data/dialogues/`, `data/enemies/`, `data/items/`, `data/quests/`, `data/locations/`
- Assets: `assets/generated/placeholders/`, `assets/runtime/`
- Third-party: `third_party/assets/kenney-pixel-ui-pack/`, `credits/THIRD_PARTY_ASSETS.md`
- Validation support: `tools/`, `tests/`
