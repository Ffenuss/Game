# Правила Godot 4.6 проекта

Этот документ фиксирует инженерные правила именно для данного репозитория.

## 1. Project settings

- Использовать `project.godot` как источник правды.
- Не менять renderer без причины и явного решения.
- Не коммитить experimental setup без документации.
- Все изменения settings должны описываться в `docs/DECISIONS.md` и `docs/CHANGELOG.md`, если они влияют на игру.

## 2. Renderer

- Проект использует `Compatibility` renderer.
- Не переходить на `Forward+` ради “красивее”.
- Держать pixel-art-friendly defaults.

## 3. Android orientation

- Только landscape orientation.
- Не ставить UI и камеру так, будто игра будет портретной.
- Любой новый HUD должен проверяться в device-sized landscape viewport.

## 4. Input map

- Все действия должны быть явными в `Input Map`.
- Touch buttons и keyboard fallback должны ссылаться на одни и те же actions.
- Не использовать “магические” коды клавиш в логике gameplay.

## 5. Scenes

- Разделять boot, main, player, enemy, NPC, location и UI.
- Сцены должны быть reusable.
- Не смешивать world logic и menu logic в одном root-узле без причины.

## 6. Nodes

- Для игрока использовать `CharacterBody2D`.
- Для лёгких врагов использовать `CharacterBody2D` или лёгкую `Node2D`-логику.
- Для HUD использовать `CanvasLayer` + `Control`.
- Для визуального фона использовать `CanvasLayer`, `ColorRect`, `Sprite2D` или аналоги, если они дешевле и понятнее.

## 7. TileMapLayer

- Использовать `TileMapLayer`, не deprecated `TileMap`.
- Локация должна быть слоистой и редактируемой.
- У каждого слоя должна быть ясная функция.

## 8. CharacterBody2D

- Игрок должен иметь читаемую скорость, ускорение и торможение.
- Диагональное движение должно нормализоваться.
- Dodge должен иметь короткую неуязвимость.

## 9. Signals

- Использовать сигналы для:
  - change of health;
  - stamina updates;
  - interaction prompts;
  - quest updates;
  - checkpoint activation;
  - dialogue open/close.
- Не читать состояние другого узла каждую секунду, если это проще и чище через signal.

## 10. Autoloads

Рекомендуемые автолоады:

- `GameState`
- `SaveManager`
- `AssetCatalog`
- `QuestManager`
- `SceneRouter`

Правила:

- автолоады должны быть маленькими;
- они не должны хранить всё подряд;
- если логики стало много, выносить её в отдельный компонент/сцену/ресурс.

## 11. Resources

- Reusable data should live in Resources or JSON where it makes sense.
- Use them for items, quests, dialogue, and location descriptors.
- Do not lock static content into scripts if it can be externalized cleanly.

## 12. GDScript style

- GDScript only.
- Typed GDScript where practical.
- Short scripts preferred.
- One responsibility per script.
- Avoid monolithic managers and circular dependencies.

## 13. Save files

- Local save files only.
- Save should be versioned or at least migratable.
- Missing or corrupted save must fail safe.
- Use `FileAccess` carefully and log the issue.

## 14. UI

- Use `Control` anchors and containers.
- Preserve playfield in normal gameplay.
- Keep labels Russian.
- Keep touch targets large enough for phones.
- Avoid giant permanent overlays.

## 15. Asset references

- Do not scatter raw paths.
- Prefer `AssetCatalog`.
- Preserve canonical runtime paths.
- Do not reference `third_party/` directly from scenes.

## 16. Performance

- Favor lightweight effects.
- Use small maps and compact atlases.
- Avoid per-frame allocations in hot paths.
- Keep transparent overlays to a minimum.
- Avoid expensive shaders unless profiling proves they are safe.

## 17. Export

- Android export needs signing, versioning, and preset verification.
- APK/AAB/keystores must never be committed.
- Visual and input QA must happen on device before release claims.

## 18. Validation

- Every new feature must have a validation path.
- Documentation-only tasks may not need runtime smoke, but any scene/script/asset change does.
- Record command and exit code whenever available.

