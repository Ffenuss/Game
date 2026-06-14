# Текущий статус проекта

## 1. Краткий вывод

Проект находится на стадии **playable vertical slice**.

Он уже запускается как Android-first Godot 4.6 игра, в нём есть первый playable loop, но это ещё **не Android release candidate** и тем более не полный релиз.

## 2. Что уже готово

### Project foundation

- `project.godot` существует и настроен под Godot 4.6.
- Используется `Compatibility` renderer.
- Проект остаётся GDScript-only.
- Главный boot flow и title screen уже работают.
- Есть модульная структура сцен, скриптов, данных и ресурсов.

### Android settings

- Проект ориентирован на landscape.
- Touch-first HUD уже есть.
- Keyboard fallback для тестирования сохранён.
- Android-специфичные правила уже задокументированы.
- Committed `export_presets.cfg` пока нет.

### Player

- Игрок реализован через `CharacterBody2D`.
- Есть движение, ускорение и нормализованная диагональ.
- Есть атака, рывок, получение урона, смерть и респавн.
- Камера следует за игроком.

### Controls

- Есть виртуальный джойстик.
- Есть touch-кнопки атаки, рывка, взаимодействия, лечения, инвентаря и паузы.
- Есть keyboard fallback для развития и проверки.

### HUD

- HUD уже вынесен в отдельную сцену.
- Есть health/stamina панели.
- Есть interaction prompt.
- HUD уже компактнее, чем в раннем прототипе, и текущий rescue pass прижимает его ещё сильнее к углам.
- Подписи кнопок стали компактнее, а общий UI helper теперь задаёт единый язык для модальных экранов.
- Есть общий UI helper для title, pause, dialogue, inventory, journal, quest toast и HUD.

### World/level

- Есть первая компактная зона `collapsed_bridge`.
- Есть переход в `old_ledge`.
- Уровни построены на `TileMapLayer`.
- Есть сцены и данные для дальнейшего расширения карты.
- `Обрушенный мост` был расширен и переформатирован для visual rescue pass, чтобы первый скриншот читался как реальная локация.
- Генерируемый тёмный world backdrop теперь закрывает серые поля вокруг сцены, а spawn path игрока снова исправлен.

### Combat

- Есть `HealthComponent`, `StaminaComponent`, `HitboxComponent`, `HurtboxComponent`.
- У игрока есть stamina cost, invulnerability window for dodge, hit feedback.
- Базовая melee-проверка работает.

### Enemies

- Есть `ash_mite`.
- Есть `hollow_miner` stub/placeholder для расширения.
- Есть `training_dummy` для теста удара.

### Checkpoint

- Есть `Камень Тепла`.
- Есть checkpoint activation.
- Есть respawn-логика.

### Save/load

- Есть `SaveManager`.
- Есть локальный слот сохранения.
- Есть сохранение состояния игрока, чекпоинта и данных мира.

### NPC/dialogue

- Есть Тесса.
- Есть русскоязычный диалоговый файл.
- Диалог открывается отдельной сценой.

### Quest

- Есть первый квест `Пепел под кожей`.
- Journal показывает human-readable title and objective.

### Inventory

- Есть inventory scaffold.
- Есть предметы-рычаги для теста.
- Есть отображение описания и количества.

### Journal

- Journal открыт как отдельная сцена.
- Показывает активный квест и текущую задачу.

### Assets

- Есть procedural placeholder pipeline.
- Есть normalized runtime assets.
- Есть asset manifest.
- Есть архивированный CC0 UI scaffold.

### Documentation

- Есть game bible.
- Есть asset/license/source policy docs.
- Есть Android testing notes.
- Есть release audit, blockers, changelog, roadmap and workflow docs.

### Validation

- Headless Godot validation уже проходила ранее в этом репозитории.
- Structure validation и asset manifest validation есть.
- Runtime smoke validation есть.

### Git/release engineering

- Есть отдельная рабочая ветка `codex/bootstrap-rpg`.
- Есть аккуратная история коммитов.
- Рабочее дерево до текущего этапа было чистым.

## 3. Что работает, но требует полировки

- HUD уже компактнее, но его нужно проверить на реальном Android-экране.
- Mobile buttons уже стали меньше и дальше от центра, но device-side readability ещё не подтверждена.
- Dialog, inventory, journal и pause menu уже есть, но их presentation layer всё ещё ближе к prototype UI, чем к release UI.
- Камера и framing уже рабочие, но визуально ещё можно сделать более выразительными на устройстве.
- Уровень стал шире и атмосфернее, но placeholder art всё ещё доминирует.

## 4. Что не готово

- Committed Android export preset.
- Device-side Android QA pass.
- Release-quality audio pass.
- Final visual polish pass on real Android hardware.
- Android profiling pass on a mid-range device.
- Full release packaging and signing flow.

## 5. Что сломано или рискованно

- Риск №1: без committed `export_presets.cfg` проект нельзя считать готовым к стабильному Android export workflow.
- Риск №2: device-side HUD spacing и thumb reach ещё не подтверждены на реальном телефоне.
- Риск №3: placeholder-heavy visual layer может читаться как prototype until the UI skin is unified.
- Риск №4: audio отсутствует как release-ready слой.
- Риск №5: save/load и checkpoint нельзя считать device-verified без реального Android test pass.
- Риск №6: release engineering пока опирается на headless validation, а не на полноценный Android export pipeline.

## 6. Готовность в процентах

- Technical prototype readiness: **90%**
  - Основа, сцены, данные и системные scaffold уже есть.
- Playable vertical slice readiness: **82%**
  - Loop playable, но presentation, export и device QA ещё не доведены.
- Android release-candidate readiness: **55%**
  - Нужны export preset, device QA, performance check и final UI pass.
- Full commercial release readiness: **12%**
  - Слишком много контента, аудио, polish и production hardening ещё впереди.

## 7. Следующий лучший этап

**Проверка скриншота на Android для M1 visual rescue pass, затем Android export prep**.

Почему именно он:

- Core loop уже существует и не требует расширения ради этой правки.
- The current visual rescue pass is now implemented and should be verified before build/export infrastructure work resumes.
- The biggest visible blocker is still the screenshot composition, which must be checked on Android hardware.
- A committed export preset is still required before Android release discipline can tighten further.
- This work has low gameplay risk and high visible impact.
