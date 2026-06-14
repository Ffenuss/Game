# Release Audit

## Overall status

- Target: Android-first Godot 4.6 vertical slice
- Working title: `Пепельный Дол: Клеймо Пустоши`
- Release candidate status: not yet ready for a public Android release
- Vertical slice status: playable, but still partial on polish and device QA

## 1. Core loop

Status: PARTIAL

- Evidence: `scenes/main/title_screen.tscn`, `scenes/main/main.tscn`, `scripts/core/boot.gd`, `scripts/core/main_root.gd`, `scripts/player/player.gd`.
- Missing: full Android device confirmation and edge-case validation under touch input.
- Next action: verify the playable loop on a real Android device after the UI pass.

## 2. Android controls

Status: PARTIAL

- Evidence: `scenes/ui/mobile_hud.tscn`, `scripts/ui/mobile_hud.gd`, `scripts/ui/virtual_joystick.gd`.
- Missing: final device-side readability, safe-zone spacing, and thumb reach checks.
- Next action: confirm the compact HUD on a handset screenshot.

## 3. HUD/UI

Status: PARTIAL

- Evidence: modal UI exists for title, pause, dialogue, inventory, journal, and quest update, and `scripts/ui/ui_style.gd` now applies a shared presentation layer.
- Missing: Android device screenshot confirmation for safe margins and final readability.
- Next action: verify the current UI skin on real hardware and keep the layout tight.

## 4. Camera/view composition

Status: PARTIAL

- Evidence: `scripts/player/player.gd` sets follow camera zoom; `scenes/main/main.tscn` adds a dark backdrop and vignette; `data/locations/collapsed_bridge.json` has been widened and re-centered for the M1 visual rescue pass.
- Missing: device-side screenshot confirmation that the playfield composition feels intentional.
- Next action: confirm the updated HUD does not compete with the central play area.

## 5. Level readability

Status: PARTIAL

- Evidence: `data/locations/collapsed_bridge.json` now carries the widened first-chapter framing, `data/locations/old_ledge.json`, `scripts/world/location_scene.gd`.
- Missing: final phone-sized readability pass and later content expansion.
- Next action: keep the current compact map readable after the UI update and verify the screenshot no longer reads like a test room.

## 6. Visual style

Status: PARTIAL

- Evidence: generated placeholders, normalized runtime assets, and the backdrop/vignette layer already used in the main scene.
- Missing: final unified presentation layer and later bespoke art replacements.
- Next action: finish the current presentation pass before adding new content.

## 7. Player feel

Status: PARTIAL

- Evidence: movement, attack, dodge, hit, death, respawn, and camera-follow logic are in `scripts/player/player.gd`.
- Missing: Android hardware feel validation and final tuning values on real input latency.
- Next action: re-check after the UI pass so the control layout is stable.

## 8. Combat

Status: PARTIAL

- Evidence: `scripts/core/health_component.gd`, `scripts/core/stamina_component.gd`, `scripts/combat/hitbox_component.gd`, `scripts/combat/hurtbox_component.gd`, `scripts/enemies/enemy_base.gd`.
- Missing: full mobile tuning and device-side failure-state validation.
- Next action: validate stamina, dodge, hit feedback, and enemy response on a device.

## 9. Enemies

Status: PARTIAL

- Evidence: `scripts/enemies/` contains the ash mite and miner scaffolding.
- Missing: Android hardware confirmation that enemy readability and attacks feel fair.
- Next action: verify the current enemy set once the HUD layout is stable.

## 10. Checkpoint/respawn

Status: PARTIAL

- Evidence: `scripts/core/checkpoint_component.gd`, `scripts/autoload/save_manager.gd`, `GameState` respawn snapshot flow.
- Missing: real Android device re-test after UI and flow changes.
- Next action: confirm `Камень Тепла` still restores and respawns cleanly.

## 11. Save/load

Status: PARTIAL

- Evidence: one local save slot, `user://save_slot_1.json`, plus save/load scaffolding in `SaveManager`.
- Missing: device-side verification with a real mobile app restart and corrupted-save fallback check.
- Next action: retest after the presentation pass, before export prep.

## 12. NPC/dialogue

Status: PARTIAL

- Evidence: `data/dialogues/tesa_intro.json`, `scripts/ui/dialogue_panel.gd`, NPC scaffolding for Тесса.
- Missing: final device readability and UI consistency with the rest of the modal surfaces.
- Next action: apply the same UI language to the dialogue panel.

## 13. Quest/journal

Status: PARTIAL

- Evidence: `data/quests/ash_under_skin.json`, `scripts/autoload/quest_manager.gd`, `scripts/ui/journal_panel.gd`.
- Missing: Android device QA for the journal and quest update surfaces.
- Next action: keep the quest UI readable and consistent across modal screens.

## 14. Inventory

Status: PARTIAL

- Evidence: `scripts/ui/inventory_panel.gd`, `data/items/`, `GameState.inventory_snapshot`.
- Missing: final mobile readability and visual consistency with the rest of the UI.
- Next action: finish the shared styling pass so inventory matches the title/pause/dialogue skins.

## 15. Audio feedback

Status: NOT READY

- Evidence: no release-quality audio pipeline is present in the current inspection scope.
- Missing: SFX/music pass and Android-safe mix.
- Next action: defer until the slice presentation and export prep are stable.

## 16. Performance

Status: PARTIAL

- Evidence: lightweight 2D nodes, compact data-driven maps, placeholder assets, Compatibility renderer.
- Missing: profiling on a mid-range Android device.
- Next action: profile after the UI pass and before any release candidate claim.

## 17. Android export

Status: NOT READY

- Evidence: `project.godot` is configured, but no committed `export_presets.cfg` is present.
- Missing: package/signing config and export verification.
- Next action: prepare a safe export preset after the current visual pass.

## 18. Device QA

Status: PARTIAL

- Evidence: headless structure/manifest/runtime validation exists and has passed in the repository history.
- Missing: Android Editor/device-side screenshot and control QA for the current build state.
- Next action: run the current slice on Android hardware and record screenshots.

## 19. Asset licensing

Status: READY

- Evidence: `data/assets/asset_manifest.json`, `credits/THIRD_PARTY_ASSETS.md`, runtime placeholder pipeline, and source/license docs.
- Missing: nothing blocking for the current slice.
- Next action: only add new assets through the documented intake policy.

## 20. Documentation

Status: PARTIAL

- Evidence: game bible, source policy, license policy, Godot rules, Android rules, visual style guide, workflow docs, and checklists already exist.
- Missing: live status/roadmap tracking that reflects the current release-prep state.
- Next action: keep `CURRENT_PROJECT_STATUS.md`, `RELEASE_AUDIT.md`, `NEXT_DEVELOPMENT_PLAN.md`, and `PLANS.md` synchronized.

## 21. Git/release engineering

Status: PARTIAL

- Evidence: dedicated branch `codex/bootstrap-rpg`, incremental commit history, no forbidden build artifacts in the tree.
- Missing: export preset, Android build verification, and final release checkpoint discipline.
- Next action: once the M1 visual rescue pass is validated, move to Android export prep and device QA.

## Release conclusion

- The project is a playable vertical slice.
- It is not yet a release candidate for public Android distribution.
- The remaining work is polish, export setup, and device-side verification rather than large-scale feature development.
