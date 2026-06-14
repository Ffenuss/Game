# Asset Policy

## Allowed automatically

- CC0
- Public domain assets with explicit proof

## Require explicit approval first

- CC-BY
- OGA-BY
- MIT/BSD art packs
- Attribution-required assets
- Assets with unclear commercial-use wording

## Rejected

- GPL or LGPL assets
- CC-BY-SA, CC-NC, CC-ND
- Unknown licenses
- Custom licenses without review
- Ripped or mirrored commercial assets
- Random search-engine images

## Source domains

Preferred:

- `kenney.nl`
- `opengameart.org`

Documentation or Godot-specific sources only:

- `godotengine.org`
- `docs.godotengine.org`
- official Godot Asset Library

## Normalization rules

- Keep source files in `third_party/assets/`.
- Normalize selected files into `assets/runtime/`.
- Keep generated placeholders in `assets/generated/placeholders/` and normalize them into runtime paths when they are used by scenes.
- Archive license proof for every imported third-party file.
- Update `data/assets/asset_manifest.json` when any asset changes.

