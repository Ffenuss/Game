# Tools

These scripts are intended to be run from Godot headless or the Android Editor workflow when available.

- `generate_placeholder_assets.gd`: regeneration hook for the placeholder art pipeline.
- `normalize_assets.gd`: normalization hook for copying selected source assets into canonical runtime paths.
- `validate_asset_manifest.gd`: checks manifest structure, hashes, and referenced files.
- `validate_runtime_smoke.gd`: headless startup smoke check that launches the boot scene and waits a few frames.
- `validate_project_structure.gd`: checks repository layout and forbidden references.
- `generate_test_world.gd`: regeneration hook for the location JSON layouts.

The repository already includes the generated placeholder images, normalized runtime copies, and location JSON files needed for the bootstrap slice.
