# Plans

## Current Phase

Documentation architecture pass: create the permanent game development bible and supporting rulebooks so future Codex work has one authoritative source for architecture, assets, licensing, Android rules, QA, and workflow.

## Current Diagnosis

- Working: the repository already has a playable Android-first Godot vertical slice, modular code, an asset pipeline, and a prior documentation base.
- Incomplete: the repository lacks a single canonical production handbook with clear “what to do / what not to do” rules, current 2026 asset source guidance, and explicit Codex workflow requirements.
- Broken or risky: the existing documentation is distributed across several smaller files, which is workable but not authoritative enough for future agents without a stronger top-level handbook.
- Planned improvement: add a permanent documentation book in Russian, add 2026 asset source and license policy docs, create explicit Godot/Android/game rules, and update AGENTS.md so every future task reads the right files first.
- Status after this task: the permanent documentation set has been created and the cross-links now point future work at the correct canonical sources.

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
- Identified the need for a permanent documentation bible and supporting rulebooks before any further gameplay or asset changes.
- Created the permanent game development bible and supporting rulebooks for asset sources, licensing, Godot 4.6 rules, Android rules, visual style, Codex workflow, production checklists, and source update policy.
- Updated `AGENTS.md` so future Codex tasks must read the new canonical docs first.
- Updated existing docs and README cross-links so the new documentation hierarchy is explicit.

## Next Safe Steps

1. Verify any future gameplay or asset task begins by reading the new canonical docs.
2. If the repository continues with production work, keep updating the bible and rulebooks whenever a rule changes.
3. Keep documentation-only changes separate from gameplay changes where practical.

## Blockers

- No code blocker is currently confirmed.
- Android Editor and device-side screenshot QA remain required for the visual pass, but they are not the goal of this documentation task.
- Android export setup still needs verification in a later pass.
- The repository needs a single authoritative documentation book before future work continues.
- No asset import or gameplay work was performed in this documentation pass.

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
- Documentation-only pass: no runtime validation is required beyond static repository checks unless a file change touches scenes, scripts, or assets.
- `git diff --check` passed after the documentation updates.
- `validate_project_structure.gd` exit `0` after the documentation updates.
- `validate_asset_manifest.gd` exit `0` after the documentation updates.
- `validate_runtime_smoke.gd` exit `0` and started `res://scenes/main/title_screen.tscn`.

## Manual Android Testing Requests

1. Run the project in Godot 4.6 Android Editor.
2. Confirm landscape orientation and Compatibility renderer.
3. Confirm the HUD buttons stay in the lower-right thumb zone.
4. Confirm the joystick is smaller and less visually dominant.
5. Confirm the world no longer reads as a gray debug room.
6. Capture screenshots and logs for layout and readability review.
7. For the documentation pass, verify the new bible links and future-agent instructions only.
8. For future work, ensure each task still starts with the canonical docs sequence.

## Unresolved Questions

- None blocking for documentation creation.

## Files Changed in Current Phase

- Root config: `project.godot`, `.gitignore`, `AGENTS.md`, `PLANS.md`, `README.md`
- Docs: `docs/*.md` including architecture, asset policy, art bible, world bible, roadmap, Android testing, decisions, changelog, replacement guide, environment report, blockers, asset requests, release audit notes, plus the new game bible, source policy, license policy, Godot rules, Android rules, visual style, Codex workflow, production checklists, and source update policy
- Scripts: `scripts/autoload/`, `scripts/core/`, `scripts/player/`, `scripts/enemies/`, `scripts/npc/`, `scripts/combat/`, `scripts/dialogue/`, `scripts/quests/`, `scripts/ui/`, `scripts/world/`, `scripts/effects/`
- Scenes: `scenes/boot/`, `scenes/main/`, `scenes/player/`, `scenes/enemies/`, `scenes/npc/`, `scenes/ui/`, `scenes/locations/`
- Data: `data/assets/`, `data/dialogues/`, `data/enemies/`, `data/items/`, `data/quests/`, `data/locations/`
- Assets: `assets/generated/placeholders/`, `assets/runtime/`
- Third-party: `third_party/assets/kenney-pixel-ui-pack/`, `credits/THIRD_PARTY_ASSETS.md`
- Validation support: `tools/`, `tests/`
