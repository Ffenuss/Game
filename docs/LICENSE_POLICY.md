# Политика лицензий

Эта политика существует для того, чтобы проект можно было без риска довести до коммерческого выпуска позже.

Главный смысл: каждый файл должен быть понятен с точки зрения прав.

## 1. Main principle

Если лицензия неясна, файл не импортируется автоматически.
Если лицензия требует атрибуции, это надо явно зафиксировать.
Если лицензия запрещает коммерческое использование, такой файл не подходит для базового контура проекта.

## 2. License classes

### Green licenses

Можно использовать автоматически:

- CC0;
- Public Domain with proof;
- self-created original work;
- procedurally generated placeholders owned by this project.

### Yellow licenses

Можно использовать только после явного согласования с пользователем:

- CC-BY;
- OGA-BY;
- MIT art packs;
- BSD art packs;
- Apache-licensed non-code assets;
- OFL fonts;
- custom permissive licenses;
- attribution-required packs.

Yellow не значит “плохое”. Yellow значит “нужна явная проверка и решение”.

### Red licenses

Запрещены по умолчанию:

- GPL art;
- LGPL art;
- CC-BY-SA;
- CC-NC;
- CC-ND;
- unknown license;
- personal-use-only;
- “free” without redistribution clarity;
- ripped assets;
- fan art;
- assets from unofficial mirrors;
- AI assets with unclear rights.

## 3. Attribution policy

Даже если атрибуция не требуется по закону, она всё равно фиксируется внутренне в `credits/THIRD_PARTY_ASSETS.md`.

Правила:

- указывать creator, если он известен;
- фиксировать pack name и version;
- сохранять source page;
- указывать whether attribution is required;
- не прятать происхождение ассета.

## 4. Manifest requirements

Каждый third-party файл обязан иметь запись в `data/assets/asset_manifest.json`.

Минимум полей:

- logical asset id;
- canonical runtime path;
- original source filename;
- source page;
- source domain;
- creator name;
- asset pack name;
- pack version;
- license name;
- license proof path;
- attribution required;
- source hash;
- runtime hash;
- import date;
- processing notes;
- replacement status;
- usage locations;
- temporary or final designation.

## 5. License proof archive

Нужно архивировать:

- страницу источника;
- текст лицензии или proof;
- дату скачивания;
- автора;
- имя пакета;
- при возможности screenshot license page;
- hash файла.

Если proof невозможно сохранить из-за сайта, это надо описать в `docs/ASSET_REQUESTS.md` и не импортировать файл автоматически.

## 6. Codex behavior

Codex обязан:

- отказываться от красных лицензий;
- запрашивать явное разрешение на жёлтые лицензии;
- документировать любую неопределённость;
- предпочитать generated placeholders, если есть сомнение;
- обновлять manifest и credits при любом asset change;
- не превращать “быстро взять с сайта” в hidden risk.

## 7. Fonts rule

Шрифты считаются asset-материалом и требуют такой же дисциплины:

- исходная лицензия должна быть известна;
- архивируется license text;
- проверяется Cyrillic support;
- проверяются reserved font name rules, если шрифт модифицируется.

## 8. Audio rule

Звук тоже требует лицензии:

- CC0 or Public Domain — safe;
- CC-BY и подобные — только after approval;
- любые звуки без лицензии — нельзя;
- “обнаружено в интернете” — не лицензия.

## 9. Acceptance checklist

Перед импортом Codex должен ответить “да” на все вопросы:

- лицензия известна?
- источник стабильный?
- коммерческое использование разрешено?
- proof сохранён?
- hash можно посчитать?
- asset подходит стилю и размеру проекта?
- asset нужен сейчас?

Если хотя бы один ответ “нет”, файл не импортируется автоматически.

