# Art Bible

## Direction

Original atmospheric 2.5D pixel-art action RPG.
Three-quarter top-down view, dark fantasy, grounded silhouettes, and readable mobile composition.

## Scale

- Base tile: `16x16`
- Player frame: about `32x48`
- Enemies: one to several base tiles
- UI icons: `16x16`, `24x24`, or `32x32`
- No blurry scaling
- Nearest-neighbor filtering

## Palette

- Dark graphite
- Muted stone gray
- Cold blue-gray
- Faded brown
- Pale ash
- Warm furnace orange
- Restrained dark red for damage
- Muted green for healing

## Lighting and atmosphere

- Use light sparingly.
- Favor fake glow sprites and limited `PointLight2D`.
- Keep fog, ash, dust, and furnace flicker subtle.
- Avoid expensive effects unless profiling proves they are safe.

## Layering

Use these layers consistently:

- GroundLayer
- GroundDetailLayer
- RoadLayer
- WaterLayer
- WallLayer
- BackDecorationLayer
- CharactersLayer
- FrontDecorationLayer
- EffectsLayer
- FogLayer
- UILayer

## Style rules

- Do not copy another game's composition.
- Keep symbols and place names original.
- Prioritize clarity on small screens over ornate detail.

