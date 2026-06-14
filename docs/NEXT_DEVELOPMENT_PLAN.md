# Следующий этап разработки

The UI/presentation consistency pass was implemented in this task. The roadmap below starts with the next milestone after that pass.

## 1. Immediate next milestone

**Android export preset and release engineering prep.**

This milestone is intentionally narrow: it does not add gameplay. It makes the repository export-ready for Android without committing APK/AAB/keystores.

## 2. Why this milestone comes first

- The game loop is already playable.
- The biggest remaining release blocker is export readiness, not feature count.
- A committed export preset is required before Android release discipline can tighten further.
- This work has low gameplay risk and high operational value.
- The visual pass is already in place, so the next safe step is build/export infrastructure.

## 3. Tasks for this milestone

- Create a safe committed `export_presets.cfg` for Android.
- Document package name, version naming, and signing expectations.
- Verify the project settings that matter for Android export.
- Update Android release documentation so the export path is explicit.
- Keep APK/AAB/keystores out of the repository.

## 4. Files likely to change

- `project.godot`
- `export_presets.cfg`
- `docs/ANDROID_RELEASE.md`
- `docs/RELEASE_AUDIT.md`
- `docs/CHANGELOG.md`
- `docs/BLOCKERS.md`
- `PLANS.md`

## 5. Done criteria

- `export_presets.cfg` exists and is committed.
- Android export settings are documented and reproducible.
- The repo still does not contain APK/AAB/keystore artifacts.
- The export workflow is ready for later Android device verification.

## 6. Validation plan

- Run `git diff --check`.
- Run `tools/validate_project_structure.gd`.
- Run `tools/validate_asset_manifest.gd` if asset references change.
- Run `tools/validate_runtime_smoke.gd` if the scenes/scripts still parse.
- Verify `export_presets.cfg` parses cleanly in the repository context.
- Review the exported settings in Git status before committing.
- If Android device QA is not available, record the limitation honestly and provide manual test steps.

## 7. Next milestones after this one

1. Android device-side screenshot and control QA.
2. Save/checkpoint verification on device.
3. Combat feel tuning and failure-state polish.
4. Lightweight audio feedback pass if safe CC0 assets or generated SFX are available.
5. Optional final visual polish after real-device review.
