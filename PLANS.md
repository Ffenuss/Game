# Plans

## Current Phase

Release-prep pass: compact the mobile HUD, raise journal readability, audit release readiness, and verify the current loop still validates after polish changes.

## Current Diagnosis

- Working: title screen, boot flow, player movement, location loading, touch controls, checkpoint/save scaffolding, combat scaffolding, dialogue, quest data, inventory/journal scaffolds, and asset normalization.
- Incomplete: HUD compactness, Android export prep, device-side QA, audio polish, and first-area readability polish.
- Broken or risky: the HUD layout is too large for comfortable landscape play on phones, and Android export configuration has not yet been verified in this pass.
- Planned improvement: keep the current architecture, but reduce UI overlap, show more human-readable quest titles, and rerun validation after the edits.

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
- Updated the journal to show the quest title instead of only the raw quest ID.
- Recorded the current release-prep environment state and release audit gaps.

## Next Safe Steps

1. Re-run headless validation after the HUD and journal edits.
2. Open the project in the Android Editor and verify the compact HUD layout on a device-sized viewport.
3. Add Android export configuration and finish any remaining release notes only after the base slice stays stable.

## Blockers

- No code blocker is currently confirmed.
- Android Editor and device-side QA are still required for release confidence.
- Android export setup still needs verification in this pass.

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

## Manual Android Testing Requests

1. Run the project in Godot 4.6 Android Editor.
2. Confirm landscape orientation and Compatibility renderer.
3. Confirm the HUD buttons no longer overlap the play space excessively.
4. Confirm touch controls, collisions, combat, dialogue, quest updates, and save flow.
5. Capture screenshots for layout and readability review.

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
