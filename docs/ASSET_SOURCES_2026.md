# Открытые источники ассетов на 2026 год

Этот документ — практический каталог источников, которые можно использовать для `Пепельный Дол: Клеймо Пустоши` без нарушения лицензионной дисциплины.

Главное правило: источник сам по себе ничего не гарантирует. Проверяется каждый конкретный файл, его страница, лицензия и способ использования.

## 1. Golden rule

Каждый импортируемый файл должен иметь:

- стабильный source URL;
- автора или создателя;
- название лицензии;
- страницу лицензии или proof;
- дату скачивания;
- оригинальное имя файла;
- runtime filename;
- hash source file;
- hash runtime file;
- usage location;
- attribution status;
- replacement status.

Если хотя бы один из этих элементов неясен, ассет не импортируется автоматически.

## 2. Automatically preferred CC0 / public-domain sources

### Kenney

- Сайт: https://kenney.nl/
- Типично: CC0 / public domain on asset pages.
- Что полезно брать: UI icons, interface frames, generic sprite scaffolds, input prompts, placeholder game kits, simple effects.
- Для этого проекта: очень полезен как bootstrap-источник для UI scaffold.
- Автоиспользование: да, только если конкретная asset page и license proof подтверждают CC0.
- Что проверять: конкретную страницу пакета, included license file, не брать весь пакет без необходимости.
- Чего избегать: огромных all-in-one архивов, если нужен только маленький subset.

### OpenGameArt

- Сайт: https://opengameart.org/
- Типично: множество лицензий, включая CC0, CC-BY, OGA-BY, GPL и др.
- Что полезно брать: pixel art, tilesets, sprites, SFX, UI, particles.
- Для этого проекта: подходит, но только после строгого фильтра по лицензии.
- Автоиспользование: только CC0 / public domain entries.
- Что проверять: license field, comments, original upload, mirrors, upload history.
- Чего избегать: OGA-BY, CC-BY-SA, GPL, unclear “free” posts.

### itch.io CC0-filtered assets

- Сайт: https://itch.io/game-assets/assets-cc0
- Типично: зависит от страницы; есть CC0-помеченные пакеты.
- Что полезно брать: sprites, tilesets, UI, fonts, SFX, music, icons.
- Для этого проекта: полезно для searching by category when a small CC0 pack is needed.
- Автоиспользование: только если страница явно говорит CC0/public domain.
- Что проверять: page text, author profile, included license text, downloadable archive contents.
- Чего избегать: pages marked “free” without explicit redistribution terms.

### Poly Haven

- Сайт: https://polyhaven.com/
- License: CC0.
- Что полезно брать: textures, HDRIs, reference materials, иногда модели как source reference.
- Для этого проекта: полезно как source/reference, а не как прямой 2D content dump.
- Автоиспользование: да, CC0 proof straightforward.
- Что проверять: actual file license page, update date, file size for Android constraints.
- Чего избегать: importing high-res textures without downscaling.

### ambientCG

- Сайт: https://ambientcg.com/
- License: CC0.
- Что полезно брать: ground/stone/wood texture references, material bases, possible source for tile processing.
- Для этого проекта: очень полезно как сырьё для процедурных или pixelized ground tiles.
- Автоиспользование: да, после проверки конкретной asset page.
- Что проверять: license page, download options, texture sizes.
- Чего избегать: брутфорс загрузки гигабайт материалов.

### Freesound CC0 filter

- Сайт: https://freesound.org/
- Типично: CC0, CC-BY, CC-BY-NC и другие.
- Что полезно брать: UI clicks, hits, footsteps, ambient loops, checkpoint sounds.
- Для этого проекта: подходит для малых SFX.
- Автоиспользование: только CC0 sounds.
- Что проверять: exact sound page, license tag, uploader, any attribution notes, sample rate and length.
- Чего избегать: NC, CC-BY, “attribution encouraged but not required” confusion.

### Wikimedia Commons

- Сайт: https://commons.wikimedia.org/
- Типично: public domain и свободные лицензии, но не всё одинаково безопасно.
- Что полезно брать: public-domain reference images, some textures, historical object references.
- Для этого проекта: скорее как reference and proofed public-domain source, не как массовый art source.
- Автоиспользование: только public domain / clearly free files with proof.
- Что проверять: file page, license template, author, country-of-origin note, reuse guidance.
- Чего избегать: случайные files without license understanding.

### Self-generated original placeholders

- Source: local generator in `tools/generate_placeholder_assets.gd`
- License status: original generated placeholder
- Что полезно: almost everything temporary for the slice.
- Для этого проекта: основной fallback, если внешний источник не нужен.
- Автоиспользование: yes, because it is original to the project.
- Что проверять: that generation is documented and deterministic enough for replacement.

## 3. Useful sources with caution

### Godot Asset Library

- Сайт: https://docs.godotengine.org/en/stable/community/asset_library/index.html
- Типично: MIT, GPL, CC0, BSD, open-source mixed.
- Полезно для: addons, templates, demos, tools, compatible scripts.
- Для этого проекта: только когда addon действительно снижает сложность и не вводит native dependencies.
- Автоиспользование: no. Only after license review and compatibility check.
- Что проверять: engine version support, license consistency, no native plugin dependency, Android Editor compatibility.
- Чего избегать: paid assets, complex addons, mixed-license surprises.

### Google Fonts

- Сайт: https://fonts.google.com/
- Типично: OFL, Apache, other open font licenses.
- Полезно для: readable UI fonts, Cyrillic support.
- Для этого проекта: useful for final text readability, but font license must be archived.
- Автоиспользование: only after license file/proof is archived.
- Что проверять: exact font family license, license text, Cyrillic coverage, reserved font names.

### SIL font ecosystem

- Сайт: https://software.sil.org/
- Типично: SIL Open Font License.
- Полезно для: UI fonts, readable Cyrillic text, robust open fonts.
- Для этого проекта: very useful for interface readability.
- Автоиспользование: only after OFL text is archived.
- Что проверять: font package license, modification rules, reserved names.

### BlenderKit

- Сайт: https://www.blenderkit.com/
- Типично: mixed licensing and account-based distribution.
- Полезно для: reference or occasional 3D texture/model source.
- Для этого проекта: low priority.
- Автоиспользование: no, only after careful license review.
- Чего избегать: import by convenience.

### GitHub open asset repos

- Сайт: https://github.com/
- Типично: depends entirely on repo license.
- Полезно для: tools, small utilities, occasional open asset packs.
- Для этого проекта: only if repo has clear license and stable source.
- Автоиспользование: no by default.
- Что проверять: LICENSE file, repository stability, tags/releases, asset provenance.

### Pixabay / other free media sites

- Site: https://pixabay.com/
- Типично: custom free license with terms.
- Полезно для: reference, maybe simple SFX or generic images.
- Для этого проекта: only when license terms are archived and compatible.
- Автоиспользование: no.

## 4. Rejected sources by default

Never auto-import from:

- Pinterest;
- Google Images;
- random search result mirrors;
- ArtStation or DeviantArt random downloads;
- Reddit uploads;
- Discord attachments;
- Telegram file shares;
- fan recreation packs;
- extracted commercial game files;
- screenshots ripped from other games;
- “free for personal use” packs;
- “royalty-free” packs with unclear redistribution terms;
- AI asset dumps with unclear training/output rights;
- unofficial mirrors;
- any file without a stable source page.

## 5. Category table

| Category | Preferred sources | Acceptable licenses | Risk | Notes |
| --- | --- | --- | --- | --- |
| Pixel sprites | Kenney, OpenGameArt CC0, itch.io CC0 | CC0, Public Domain | Low if proofed | Use only if silhouette and scale fit the project |
| Tilesets | Kenney, OpenGameArt CC0, ambientCG-derived bases | CC0, Public Domain | Low-medium | Downscale and normalize for Android |
| UI icons | Kenney, itch.io CC0, self-generated | CC0, PD | Low | Prefer icon-first, compact Android-friendly art |
| Fonts | Google Fonts, SIL | OFL, Apache, UFL variants | Medium | Archive license and verify Cyrillic support |
| SFX | Freesound CC0, self-generated | CC0, PD | Low | Keep files small and loops clean |
| Music | Freesound CC0, itch.io CC0, self-generated | CC0, PD | Medium | Avoid large files and busy loops |
| Particles | Kenney, self-generated, OpenGameArt CC0 | CC0, PD | Low | Prefer tiny particle sprites |
| 3D reference | Poly Haven, ambientCG, Wikimedia Commons PD | CC0, PD | Low | Primarily for reference or texture source |
| Tools | Godot Asset Library, GitHub repos | varies | Medium-high | Only after license and Android compatibility review |

## 6. Dark-fantasy Android RPG shopping list

| Needed | Placeholder now | Source strategy | Priority | Replacement path |
| --- | --- | --- | --- | --- |
| Player sprite sheet | Yes | Final original art or CC0 scaffold only | High | `assets/runtime/characters/` |
| Ash mite enemy | Yes | Original or CC0 scaffold | High | `assets/runtime/enemies/` |
| Hollow miner enemy | Yes | Original or CC0 scaffold | Medium | `assets/runtime/enemies/` |
| Petrified wolf enemy | Yes | Original or CC0 scaffold | Medium | `assets/runtime/enemies/` |
| Тесса NPC | Yes | Original or placeholder portrait | High | `assets/runtime/characters/` |
| Village tiles | Yes | Original tiles / CC0 scaffolding | High | `assets/runtime/tilesets/` |
| Forest tiles | Yes | Original tiles / CC0 scaffolding | High | `assets/runtime/tilesets/` |
| Mine tiles | Yes | Original tiles / CC0 scaffolding | High | `assets/runtime/tilesets/` |
| Broken bridge tiles | Yes | Original tiles / CC0 scaffolding | High | `assets/runtime/tilesets/` |
| Checkpoint object | Yes | Original icon/glow | High | `assets/runtime/effects/` |
| UI buttons | Yes | CC0 / generated | High | `assets/runtime/ui/` |
| Health/stamina bars | Yes | CC0 / generated | High | `assets/runtime/ui/` |
| Dialogue panel | Yes | CC0 / generated | High | `assets/runtime/ui/` |
| Journal panel | Yes | CC0 / generated | Medium | `assets/runtime/ui/` |
| Inventory icons | Yes | CC0 / generated | Medium | `assets/runtime/items/` |
| SFX pack | No | CC0 only after proof | Medium | `assets/runtime/audio/` |
| Ambient loops | No | CC0 only after proof | Medium | `assets/runtime/audio/` |
| Cyrillic pixel font | No | OFL/Apache after proof | High | `assets/runtime/fonts/` |

## 7. Asset intake checklist

### Before importing

- Is the source page stable?
- Is the license explicit?
- Is commercial use allowed?
- Is redistribution inside a game allowed?
- Is modification allowed?
- Is attribution required?
- Is the author known?
- Is there a license file or proof page?
- Does it fit Android size/performance constraints?
- Does it fit the current art direction?
- Is it necessary now?

### After importing

- archive source and proof in `third_party/assets/` if it is a third-party file;
- compute hashes;
- normalize to `assets/runtime/`;
- update `data/assets/asset_manifest.json`;
- update `credits/THIRD_PARTY_ASSETS.md`;
- update `docs/CHANGELOG.md`;
- run validation;
- keep the replacement contract stable.

## 8. Practical policy summary

- CC0 and proven public domain are the safest automatic sources.
- Anything with attribution requirements is not automatic.
- Anything with unclear terms is rejected.
- If in doubt, generate a placeholder and continue safely.

