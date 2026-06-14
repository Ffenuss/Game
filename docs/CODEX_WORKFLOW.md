# Рабочий процесс Codex

Этот документ описывает обязательный рабочий порядок для будущих Codex-задач в этом репозитории.

## 1. Inspect first

Перед редактированием:

1. прочитать `AGENTS.md`;
2. прочитать `docs/GAME_DEV_BIBLE.md`;
3. прочитать `docs/GODOT_46_PROJECT_RULES.md`;
4. прочитать `docs/ANDROID_GAME_RULES.md`;
5. прочитать `docs/LICENSE_POLICY.md`;
6. прочитать `docs/ASSET_SOURCES_2026.md`;
7. прочитать `PLANS.md`;
8. проверить `git status`;
9. понять, что уже работает;
10. найти, что может сломаться.

## 2. Update PLANS.md

Перед правками Codex должен отметить:

- текущую фазу;
- что мешает;
- какие файлы будут затронуты;
- какая валидация нужна;
- что будет считаться успехом.

## 3. Make one focused change

Лучше:

- один HUD pass;
- один combat fix;
- один asset import;
- один dialogue slice;
- один validation upgrade.

Плохо:

- “заодно перепишу половину проекта”;
- “пока тут, добавлю ещё 12 систем”;
- “это потом проверим”.

## 4. Validate

Нужно запускать всё, что доступно:

- static repo checks;
- manifest checks;
- runtime smoke;
- Android device QA when relevant.

Если проверка не запускалась, так и пишется.

## 5. Update docs

После завершённой фазы обновляются:

- `PLANS.md`;
- `docs/CHANGELOG.md`;
- `docs/DECISIONS.md` при архитектурном решении;
- `docs/ASSET_REPLACEMENT_GUIDE.md` при смене ассета;
- `credits/THIRD_PARTY_ASSETS.md` при импорте третьей стороны;
- `data/assets/asset_manifest.json` при изменении ассетов.

## 6. Git hygiene

- маленькие commits;
- no force push;
- no history rewrite;
- no secrets;
- no APK/AAB/keystore;
- no `.godot/`.

## 7. Report honestly

Отчёт должен явно разделять:

- что изменено;
- что проверено;
- что не проверено;
- что может быть рискованным;
- что нужно делать дальше.

## 8. Task templates

### Visual polish task

- What looks bad now?
- Which scene/HUD/art files will change?
- Which screenshot criterion will improve?
- What must stay the same?
- What device-side check is needed?

### Gameplay task

- What verb is being added or improved?
- What feedback does the player get?
- Which component or scene owns the logic?
- How is it tested?
- What can break?

### Asset import task

- Is the license green/yellow/red?
- Where is the proof?
- What is the logical asset id?
- What is the canonical runtime path?
- What gets updated in manifest and credits?

### Dialogue/quest task

- What text changes?
- What triggers the state change?
- How is the journal updated?
- What is the fail-safe if data is missing?

### Save/load task

- What is saved?
- What versioning/migration risk exists?
- What happens on corruption?
- What is the fallback state?

### Bugfix task

- What is the symptom?
- How is it reproduced?
- Which file actually owns the problem?
- What regression tests are needed?

### Export task

- Which platform?
- Which signing files?
- Which preset?
- What must never be committed?
- What manual QA is required?

