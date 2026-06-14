# Android Release Notes

## Current state

- The project is Android-first and runs in the Godot 4.6 Android Editor workflow.
- A committed `export_presets.cfg` was not present during this release-prep pass.
- Android export setup still needs to be completed before a real release build.

## Required steps for export

1. Install the matching Godot 4.6 export templates.
2. Open `Project -> Export` in Godot.
3. Add an Android preset.
4. Set the package name, version code, and version name.
5. Choose the Compatibility renderer and landscape orientation settings already used by the project.
6. Configure debug and release keystores.
7. Export a debug APK for device testing.
8. Export a release APK or AAB only after signing is configured and verified.

## What must not be committed

- Keystore files.
- Passwords or credentials.
- Exported APK or AAB artifacts.
- `.godot/` cache data.

## Manual checks before release export

1. Confirm the project runs in the Android Editor.
2. Confirm the HUD is readable on a real device.
3. Confirm movement, combat, checkpoint, dialogue, quest, inventory, and journal flows.
4. Confirm no missing asset warnings appear during startup.
5. Confirm the build is signed with the intended release keystore.

## Known limitation

- The repository still needs final Android export configuration and device verification before it can be treated as release-ready.
