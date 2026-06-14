# Визуальный стиль

Этот документ описывает художественный и композиционный язык `Пепельный Дол: Клеймо Пустоши`.

## 1. Art direction

Направление:

- atmospheric 2.5D pixel-art action RPG;
- three-quarter top-down view;
- dark fantasy;
- grounded silhouettes;
- compact mobile readability;
- restrained ornamentation.

Игрок должен ощущать:

- холод долины;
- пепел в воздухе;
- камень и дерево как старые, тяжёлые материалы;
- тёплый furnace light как редкий источник надежды.

## 2. Palette

Основная палитра:

- dark graphite;
- muted stone gray;
- cold blue-gray;
- faded brown;
- pale ash;
- warm furnace orange;
- restrained dark red for damage;
- muted green/blue for healing and stamina.

Правила:

- избегать неона;
- избегать “web-purple” дефолтности;
- сохранять раздельность фона, декора, персонажей и UI;
- не смешивать десятки ярких цветов без необходимости.

## 3. Pixel scale

- Base tile: `16x16`.
- Character frame: around `32x48`.
- UI icons: `16x16`, `24x24`, `32x32`.
- Larger enemies: multiple of base tile.
- No blurry scaling.
- Nearest-neighbor filtering is required.

## 4. Sprite readability

Силуэт должен читаться раньше деталей.

Обязательные условия:

- player instantly distinguishable from floor;
- enemy visually different from rubble or decor;
- checkpoint visibly warm;
- interactables visually “callable”;
- NPC has distinct posture or color accent.

## 5. Tileset readability

- Ground should not look like one endless noisy texture.
- Paths should lead the eye.
- Cliffs and walls should frame space.
- Water should contrast with walkable surfaces.
- Decorative clusters should create rhythm, not clutter.

## 6. UI visual language

- Compact panels.
- Rounded or softened corners.
- Dark framed surfaces with warm/cold accents.
- Short labels in Russian.
- Icon-first controls where possible.
- Buttons must look like game controls, not debug widgets.

## 7. Dark fantasy atmosphere

Atmosphere should come from:

- ash particles;
- subtle fog;
- warm checkpoint glows;
- dim lantern/furnace accents;
- worn stone and wood;
- quiet negative space.

Не использовать:

- лишний шум;
- постоянные flash effects;
- чрезмерный glow;
- “epic” fantasy over-decoration that breaks mobile readability.

## 8. Lighting and fog

- Use light sparingly.
- Prefer simple glow sprites when they are enough.
- Fog should be subtle, not opaque.
- Keep the scene legible under all effects.

## 9. Placeholder rules

Temporary art must:

- be original;
- be readable;
- keep the palette coherent;
- never look like random gray boxes;
- preserve canonical runtime paths when replaced later.

Placeholders are scaffolding, not final identity.

## 10. Final asset replacement rules

When final art replaces a placeholder:

- preserve logical asset ID if possible;
- keep runtime path stable if practical;
- update manifest hashes;
- update credits if third-party;
- validate that scene references still work;
- do not silently break scale or frame names.

## 11. Screenshot quality checklist

Before calling the visual pass acceptable:

- HUD does not cover the playfield center;
- joystick is not visually dominant;
- action buttons are thumb-zone friendly;
- bars are readable and compact;
- world fills the screen naturally;
- no gray editor-like empty area dominates;
- bridge/path/collision boundaries are readable;
- checkpoint and interact prompts stand out;
- pixel art stays crisp;
- no severe overdraw or obvious lag.

