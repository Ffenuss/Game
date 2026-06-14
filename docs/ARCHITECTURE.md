# Architecture

The project is organized to keep gameplay modular and asset replacement safe.

## Autoloads

- `GameState`: global runtime state, player-facing settings, current location, respawn data.
- `SaveManager`: local JSON save/load for the single save slot.
- `AssetCatalog`: logical asset ID resolution, placeholder fallback, and manifest loading.
- `QuestManager`: quest state, journal text, and quest update signals.
- `SceneRouter`: location switching inside the persistent main scene.

## Scene flow

`scenes/boot/boot.tscn` starts the app, then routes to the title screen.
`scenes/main/main.tscn` hosts the persistent world container and UI layer.
Location scenes live in `scenes/locations/` and are data-driven from JSON in `data/locations/`.

## Reusable components

- `HealthComponent`
- `StaminaComponent`
- `HitboxComponent`
- `HurtboxComponent`
- `CheckpointComponent`
- `DialogueTriggerComponent`
- `QuestTriggerComponent`

## World structure

Each location scene uses layered `TileMapLayer` nodes:

- `GroundLayer`
- `GroundDetailLayer`
- `RoadLayer`
- `WaterLayer`
- `WallLayer`
- `BackDecorationLayer`
- `CharactersLayer`
- `FrontDecorationLayer`
- `EffectsLayer`
- `FogLayer`
- `SpawnPoints`
- `Interactables`
- `UILayer`

## Data flow

- Structured content lives in JSON files under `data/`.
- Assets resolve through `data/assets/asset_manifest.json`.
- Scenes ask `AssetCatalog` for a logical asset ID instead of hard-coding raw paths.
- `SaveManager` reads and writes only local save data.

## Design rules

- Prefer composition over inheritance.
- Keep scripts small and focused.
- Keep map edits in data or scene nodes, not hard-coded in unrelated systems.
- Never reference `third_party/` files directly from gameplay scenes.

