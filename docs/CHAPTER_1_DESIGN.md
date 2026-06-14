# Глава 1: Пепел под кожей

## 1. Purpose

Эта глава должна научить игрока:

- movement;
- attack;
- dodge;
- stamina;
- interaction;
- checkpoint;
- dialogue;
- quest journal;
- first enemy behavior;
- first save.

Она не должна пытаться рассказать всю игру сразу.

## 2. Opening flow

Старт главы:

1. Игрок просыпается у **Обрушенного моста**.
2. Видит пепел, холодный туман и разрушенную дорогу.
3. Находит первый tutorial marker.
4. Доходит до **Камня Тепла**.
5. Пробует удар по dummy или раннему врагу.
6. Встречает **Тессу** на **Старом Уступе**.
7. Получает или обновляет квест.
8. Узнаёт путь к **Каменному Лесу** и входу в штольню.

## 3. Visual mood

Визуальный язык главы:

- dark graphite cliffs;
- ash falling from a clear sky;
- cold gray-blue ground;
- warm orange checkpoint glow;
- broken wooden bridge;
- dead trees;
- stone whispers;
- mine and furnace hints;
- sparse but readable environmental contrast.

## 4. First location redesign

**Обрушенный мост** должен восприниматься как место, а не как прямоугольная тестовая комната.

Он должен включать:

- irregular non-walkable borders;
- visual cliff edges;
- broken bridge as central landmark;
- path leading forward;
- checkpoint near the route;
- tutorial sign or stone marker;
- ash particles;
- fog;
- one small combat pocket;
- one clear exit/transition marker.

### Practical layout intent

- left side: wake-up / first step area;
- center: broken bridge and checkpoint;
- right side: forward route and transition;
- edges: cliffs, rubble, dead trees, dark framing.

## 5. Quest chain details

### Quest 1

**Пепел под кожей**

Objective text:

- Добраться до Старого Уступа.
- Поговорить с Тессой.

### Quest 2

**Следы у моста**

Objective text:

- Осмотреть мост и знак на груди.
- Дойти до Каменного Леса.

### Quest 3

**Тепло в камне**

Objective text:

- Активировать Камень Тепла.
- Подготовиться к пути в штольню.

### Quest 4

**Тропа через Каменный Лес**

Objective text:

- Пройти через лес.
- Избежать или победить ранних врагов.

### Quest 5

**Вход в штольню**

Objective text:

- Найти вход в заброшенную штольню.
- Подойти к первой внутренней зоне.

## 6. Dialogue seeds

### Тесса

Required line:

«Пепел оседает на одежде. На душе он остаётся дольше.»

### Suggested follow-up lines

- «Дыши ровно. Пепел любит паникёров больше, чем нас.»
- «Клеймо на груди не случайно загорелось именно сейчас.»
- «Если идёшь в штольню, не трогай камень без нужды.»

## 7. Combat staging

Combat в главе должен появляться поэтапно:

1. **Training dummy** near the first safe stretch for attack testing.
2. **ash_mite** in the first small hostile pocket.
3. **hollow_miner** later, near the mine route.
4. `petrified_wolf` only later, after the player already understands stamina and dodge.

Порядок нужен, чтобы игрок сначала освоил действия, а потом уже столкнулся с более опасным врагом.

## 8. Readability rules for chapter 1

- Player silhouette must stand out from the ground.
- Interactables must be warmer/brighter than background clutter.
- Checkpoint must be obvious.
- The bridge must be readable from a distance.
- The first area must never look like an empty dev room.
- HUD must never dominate the center of the screen.

## 9. Done criteria

Глава 1 не считается готовой, пока игрок не может:

- начать игру;
- понять визуальную цель первой сцены;
- добраться до checkpoint;
- поговорить с Тессой;
- увидеть/получить первый quest update;
- открыть journal и увидеть objective;
- использовать combat basics;
- дойти до первой реальной transition point;
- сохранить прогресс;
- возобновить игру после смерти или restart from checkpoint.

## 10. What this chapter is not

Это не:

- full open world;
- giant branching narrative;
- boss rush;
- loot-heavy RPG;
- elaborate skill tree demo.

Это компактный, атмосферный, playable first chapter.

