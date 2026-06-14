# Decisions

For project-wide policy and scope rules, see [GAME_DEV_BIBLE.md](GAME_DEV_BIBLE.md). This file records specific decisions and trade-offs.

## Architecture

- Use a persistent main scene plus location scenes loaded into a shared world host.
- Keep autoloads minimal and focused.
- Use JSON for location, quest, dialogue, and asset metadata.

## Rendering

- Use the Compatibility renderer for the Android-first slice.
- Use nearest-neighbor filtering and pixel snapping for crisp 2D art.

## Assets

- Use procedurally generated placeholders as the default fallback art.
- Use only verified CC0 scaffolding assets when importing third-party files.
- Keep canonical runtime paths stable so replacement does not require script rewrites.
- Store imported third-party source files only under `third_party/assets/` and normalize selected files into `assets/runtime/`.
- Keep the placeholder pipeline and the replacement contract documented so future art swaps do not require code churn.
- For temporary atlas sheets that do not yet have manifest regions, keep the slicing map inside the consuming script so replacement remains localized.

## Data loading

- Use `FileAccess.file_exists()` for JSON and text content.
- Reserve `ResourceLoader.exists()` for actual engine resources such as scenes and textures.
- For PNG runtime assets, let `AssetCatalog` fall back to direct `Image.load_from_file()` loading when headless startup cannot resolve imported resources.
- Keep dialogue, quest, item, location, and manifest data outside gameplay scripts.

## Mobile trade-offs

- Favor simple AI and lightweight particles.
- Keep UI compact and touch-first.
- Use a small vertical slice rather than a broad unfinished system set.
- Use a persistent main scene plus location scenes to keep Android memory predictable.
- Rework mobile HUD spacing with anchored controls and smaller touch targets instead of using a desktop-style overlay.
- Show the quest title in the journal so the first objective reads like a release build, not an internal identifier.

## Validation

- Headless runtime validation is part of the bootstrap and should start the boot/title scene when possible.
- Static checks and documentation updates still proceed.
- Validation scripts should fail closed on missing files and report exact paths so future Codex runs can recover quickly.
