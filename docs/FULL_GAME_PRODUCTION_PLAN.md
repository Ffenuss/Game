# План превращения прототипа в полноценную игру

## 1. Текущий диагноз

Сейчас проект уже не пустой и не сломан. В нём есть:

- титульный экран;
- основной boot flow;
- игрок с движением, атакой, рывком, стаминой и respawn;
- touch HUD и keyboard fallback;
- модульные сцены, скрипты и data-driven контент;
- checkpoint, save/load, dialogue, quest, inventory и journal scaffold;
- первая карта и переходы;
- asset pipeline и документация.

Но текущий экран всё ещё выглядит как прототип, потому что:

- локация слишком легко читается как прямоугольная тестовая комната;
- серый пустой фон или слишком пустое пространство визуально доминирует;
- HUD расположен слишком близко к центру и выглядит технически;
- кнопки и панели ещё не собраны в цельный мобильный игровой интерфейс;
- атмосфера и framing пока не превращают сцену в «место»;
- story presence есть в данных, но не в сильной презентации экрана;
- система готова к росту, но визуально ещё не ощущается как законченная chapter-1 игра.

Итог: это **playable vertical slice**, но не полноценная маленькая игра.

## 2. Целевой продукт

Цель проекта:

- Android-first dark-fantasy pixel-art action RPG;
- компактная, законченная и атмосферная первая глава;
- 30-60 минут живого первого релиза позже, если контент будет расширяться осторожно;
- локальные сохранения;
- понятный бой;
- одна сильная атмосферная область;
- простая, но читаемая quest chain;
- никаких онлайн-зависимостей;
- никакого раздутого feature creep.

Это не должен быть огромный open world.
Это должна быть маленькая, полированная, законченная и расширяемая игра.

## 3. Первая играбельная глава

### Название главы

**Глава 1: Пепел под кожей**

### Локации главы

1. **Обрушенный мост**
2. **Старый Уступ**
3. **Каменный Лес**
4. **Вход в заброшенную штольню**
5. **Заброшенная штольня** как первая малая внутренняя зона

### Основные NPC

- **Тесса** — травница, первый проводник игрока.
- **Старый горняк** или **Страж Уступа** — возможный поздний NPC главы.
- Один молчаливый раненый шахтёр или corpse-note interaction для атмосферной подсказки.

### Цепочка квестов

1. **Пепел под кожей**
2. **Следы у моста**
3. **Тепло в камне**
4. **Тропа через Каменный Лес**
5. **Вход в штольню**

### Базовые враги

- `ash_mite`
- `hollow_miner`
- `petrified_wolf` позже
- `training_dummy` только для тестирования

### Основные системы главы

- movement;
- attack;
- dodge;
- stamina;
- health;
- checkpoint;
- save/load;
- dialogue;
- quest journal;
- inventory scaffold;
- pause menu;
- Android export.

## 4. Производственные milestones

### M1. Visual rescue pass

Сделать экран не похожим на debug prototype.

### M2. First location becomes real game space

Перестроить `Обрушенный мост` в читаемую, атмосферную, многоуровневую сцену.

### M3. HUD and Android UX pass

Сделать мобильный интерфейс компактным, удобным и не перекрывающим игру.

### M4. Combat feel pass

Настроить тайминги удара, уклонения, урона, врагов и feedback.

### M5. Quest/dialogue chapter pass

Сделать квестовую цепочку главы ясной, русскоязычной и устойчивой.

### M6. Second location expansion

Расширить `Старый Уступ`, `Каменный Лес` и вход в штольню.

### M7. Save/checkpoint reliability pass

Укрепить локальные сейвы, respawn и восстановление после ошибок.

### M8. Audio/feedback pass

Добавить безопасный SFX/feedback слой.

### M9. Android export and device QA

Сделать export preset, device verification, performance checks и screenshot QA.

### M10. Release candidate cleanup

Последний polish pass, багфиксы, documentation sync и release hardening.

## 5. Что должно случиться первым

Следующий реальный шаг — **M1 Visual rescue pass**.

Почему:

- текущий экран всё ещё выглядит как прототип;
- игрок уже может играть, но presentation слоя не хватает;
- визуальный риск сейчас выше, чем риск от отсутствия новых фич;
- хороший экран даёт лучший feedback для всей последующей главы.

## 6. Definition of done for M1

Следующий скриншот должен показать:

- no dominant gray empty background;
- game world framed intentionally;
- HUD moved away from central gameplay;
- smaller joystick;
- action buttons in the lower-right thumb zone;
- compact health/stamina panel;
- more atmospheric level;
- less rectangular test-room feeling;
- clear player/interactables;
- first hint of story/world mood.

## 7. Principle for the rest of development

Сначала сделать маленький законченный chapter-1 slice.
Потом только расширять.

Нельзя добавлять широкий контент, пока:

- не читается карта;
- не читается HUD;
- не подтверждён Android control feel;
- не подтверждён save/checkpoint flow;
- не выстроена цепочка главы.

