# Asset Replacement Guide

This guide follows the canonical rules in [GAME_DEV_BIBLE.md](GAME_DEV_BIBLE.md) and [LICENSE_POLICY.md](LICENSE_POLICY.md).

## Contract

Scenes and scripts should use stable logical asset IDs from `data/assets/asset_manifest.json`.
Do not scatter raw asset paths through gameplay code.

## Canonical runtime paths

- `assets/runtime/tilesets/`
- `assets/runtime/characters/`
- `assets/runtime/enemies/`
- `assets/runtime/environment/`
- `assets/runtime/ui/`
- `assets/runtime/items/`
- `assets/runtime/effects/`
- `assets/runtime/audio/`

## Replacement flow

1. Replace the source asset in `third_party/assets/` or `assets/generated/placeholders/`.
2. Normalize the runtime file into `assets/runtime/`.
3. Update `data/assets/asset_manifest.json`.
4. Update hash values and usage locations.
5. Update `credits/THIRD_PARTY_ASSETS.md` if the file is third-party.
6. Re-run validation.

## Sprite sheet rules

- Keep tile sizes and frame sizes unchanged unless all consumers are updated together.
- Preserve animation names used by scripts.
- Keep atlas regions stable when possible.

## Validation

- Confirm the referenced runtime file exists.
- Confirm no scene points directly at `third_party/`.
- Confirm the asset still resolves through `AssetCatalog`.

## Current placeholder atlas contracts

- `assets/runtime/tilesets/ash_dol_tileset.png`
  - Dimensions: `64x64`
  - Tile size: `16x16`
  - Grid: `4x4`
  - Use: ground, cliffs, mine walls, bridge pieces, water, rubble, minerals, and transparent filler.

- `assets/runtime/characters/player_placeholder_atlas.png`
  - Dimensions: `128x288`
  - Frame size: `32x48`
  - Grid: `4x6`
  - Canonical cell order: rows advance through `idle`, `walk`, `attack_light`, `attack_heavy`, `dodge`, then `hit/death`; within each direction row, the columns are `down`, `left`, `right`, `up`.
  - Current animation names: `idle_down`, `idle_up`, `idle_left`, `idle_right`, `walk_down`, `walk_up`, `walk_left`, `walk_right`, `attack_light_down`, `attack_light_up`, `attack_light_left`, `attack_light_right`, `attack_heavy_down`, `attack_heavy_up`, `attack_heavy_left`, `attack_heavy_right`, `dodge_down`, `dodge_up`, `dodge_left`, `dodge_right`, `hit`, `death`.

- `assets/runtime/enemies/*.png`
  - Dimensions: `32x160`
  - Frame size: `32x32`
  - Grid: `1x5`
  - Canonical top-to-bottom order: `idle`, `walk`, `attack`, `hit`, `death`.
  - Current animation names: `idle`, `walk`, `attack`, `hit`, `death`.

- `assets/runtime/ui/ui_placeholder_atlas.png`
  - Dimensions: `256x256`
  - Grid: `4x4`
  - Used for bar frames, buttons, save/checkpoint icons, and other temporary UI pieces.

- `assets/runtime/ui/ui_background_vignette.png`
  - Dimensions: `640x360`
  - Use: full-screen dark backdrop and vignette framing for the Android slice.
  - Replacement rule: preserve the same viewport-sized framing contract unless the backdrop layer is reworked at the same time.

- `assets/runtime/environment/world_backdrop_mist.png`
  - Dimensions: `640x360`
  - Use: dark full-screen world backdrop under the main scene to hide prototype-gray margins and frame the first location.
  - Replacement rule: preserve the viewport-sized framing contract or update the backdrop layer and its manifest entry together.

- `assets/runtime/items/item_placeholder_atlas.png`
  - Dimensions: `128x64`
  - Grid: `4x2`
  - Canonical left-to-right order: `rusty_knife`, `miner_blade`, `healing_herb`, `key`, `living_stone_fragment`, `note`, `lantern`, `quest_seal`.
  - Used for item icons.

- `assets/runtime/effects/fx_placeholder_atlas.png`
  - Dimensions: `96x64`
  - Grid: `3x2`
  - Canonical order: `ash_particle`, `spark_particle`, `dust_particle`, `hit_flash`, `checkpoint_glow`, `mineral_glow`.
  - Used for ash, dust, spark, hit flash, checkpoint glow, and mineral glow.

- `assets/runtime/characters/npc_tessa_placeholder.png`
  - Dimensions: `32x48`
  - Use: temporary portrait and NPC placeholder silhouette.

## Replacement rules for this slice

- Keep the logical asset ID stable whenever possible.
- Preserve the runtime path whenever possible.
- If the dimensions or grid change, update the manifest, the replacement guide, and any scene/script consumers together.
- If the file comes from `third_party/assets/`, keep the source copy and license proof archived.
- Re-run validation after every replacement so downstream scene references stay auditable.
