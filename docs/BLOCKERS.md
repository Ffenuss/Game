# Blockers

## Active blockers

- The project still does not have a committed `export_presets.cfg`, so Android export is not yet release-ready.
- Android Editor/device-side screenshot QA is still required for final layout and readability verification.
- Release-quality audio has not been completed yet.
- No Godot executable is available in `PATH`, but a temporary ARM64 binary is available at `/tmp/godot-4.6.3-arm64/Godot_v4.6.3-stable_linux.arm64` for headless validation.

## Non-blocking fallback

- Continue with static file creation, asset normalization, documentation, and manual Android test instructions.
- Use the temporary ARM64 Godot binary under `/tmp/godot-4.6.3-arm64/` for headless checks when available.
