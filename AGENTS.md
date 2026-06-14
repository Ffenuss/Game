# AGENTS

Read these first before editing:

- [docs/GAME_DEV_BIBLE.md](docs/GAME_DEV_BIBLE.md)
- [docs/ASSET_SOURCES_2026.md](docs/ASSET_SOURCES_2026.md)
- [docs/LICENSE_POLICY.md](docs/LICENSE_POLICY.md)
- [docs/GODOT_46_PROJECT_RULES.md](docs/GODOT_46_PROJECT_RULES.md)
- [docs/ANDROID_GAME_RULES.md](docs/ANDROID_GAME_RULES.md)
- [docs/CODEX_WORKFLOW.md](docs/CODEX_WORKFLOW.md)
- [PLANS.md](PLANS.md)
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- [docs/ASSET_POLICY.md](docs/ASSET_POLICY.md)
- [docs/ART_BIBLE.md](docs/ART_BIBLE.md)
- [docs/WORLD_BIBLE.md](docs/WORLD_BIBLE.md)
- [docs/DECISIONS.md](docs/DECISIONS.md)
- [docs/ASSET_REPLACEMENT_GUIDE.md](docs/ASSET_REPLACEMENT_GUIDE.md)

Rules:

- Keep Android-first, landscape, Compatibility renderer, and GDScript only.
- Preserve stable runtime asset paths and update the asset registry when assets change.
- Use `TileMapLayer`, reusable scenes, and modular scripts.
- Never add unverified assets or direct references into `third_party/`.
- Preserve Russian visible UI text.
- Update docs and `docs/CHANGELOG.md` after completed features.
- Run available validation and report anything untested honestly.
- Stop before destructive changes or giant rewrites.
- Add fallback placeholders when assets are missing.
- Follow the license policy strictly and treat unclear licenses as blocked.
- Update `PLANS.md` before and after substantive work.
