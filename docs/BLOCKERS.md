# Blockers

## Active blockers

- No Godot executable is available in PATH, so headless project validation cannot be run from the default shell.
- Android export configuration still needs a committed preset and device-side verification before a real release build.
- Visual QA still needs Android Editor/device screenshot review after this polish pass.

## Non-blocking fallback

- Continue with static file creation, asset normalization, documentation, and manual Android test instructions.
- Use the temporary ARM64 Godot binary under `/tmp/godot-4.6.3-arm64/` for headless checks when available.
