# Политика обновления источников

Этот документ объясняет, как держать `docs/ASSET_SOURCES_2026.md` актуальным после 2026 года.

## 1. Verify before every import

Перед импортом любого внешнего ассета надо снова проверить:

- source page;
- creator;
- license;
- download method;
- redistribution terms;
- whether the page still exists.

## 2. Do not assume license stayed the same

Лицензия на странице может измениться.
Если source page обновился, проверка повторяется.

## 3. Record download date

Каждый импорт должен иметь дату скачивания.

Если asset когда-то спорный, дата помогает восстановить контекст.

## 4. Prefer official source pages

Использовать:

- official asset page;
- official license page;
- official project repository;
- official release notes.

Не полагаться на mirrors, reuploads и пересказы.

## 5. Avoid mirrors

Mirrors часто ломают provenance.
Если mirror нужен для восстановления, это должно быть отдельно задокументировано и не считаться первым источником.

## 6. Update the source list

Если источник изменился:

- обновить `docs/ASSET_SOURCES_2026.md`;
- отметить, что изменилось;
- при необходимости перенести источник в caution/rejected;
- при необходимости обновить `docs/LICENSE_POLICY.md`.

## 7. Mark stale sources

Источник считается stale, если:

- страница больше не отвечает;
- лицензия стала неясной;
- оригинальный автор исчез, а provenance не восстановлен;
- страницы зеркалируются без доказательств;
- платформа начала скрывать условия.

## 8. Review sources before release

Перед релизом каждый используемый внешний источник должен быть повторно просмотрен:

- актуален ли URL;
- совпадает ли license;
- есть ли proof;
- совпадает ли manifest;
- совпадает ли credits.

