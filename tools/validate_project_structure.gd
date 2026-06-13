extends SceneTree

const REQUIRED_FILES := [
	"res://AGENTS.md",
	"res://PLANS.md",
	"res://README.md",
	"res://project.godot",
	"res://docs/ARCHITECTURE.md",
	"res://docs/ASSET_POLICY.md",
	"res://docs/ART_BIBLE.md",
	"res://docs/WORLD_BIBLE.md",
	"res://docs/ROADMAP.md",
	"res://docs/ANDROID_TESTING.md",
	"res://docs/DECISIONS.md",
	"res://docs/CHANGELOG.md",
	"res://docs/ASSET_REPLACEMENT_GUIDE.md",
	"res://docs/ENVIRONMENT_REPORT.md",
	"res://docs/BLOCKERS.md",
	"res://docs/ASSET_REQUESTS.md",
	"res://credits/THIRD_PARTY_ASSETS.md",
	"res://tests/README.md",
	"res://third_party/README.md",
	"res://third_party/assets/kenney-pixel-ui-pack/License.txt",
	"res://third_party/assets/kenney-pixel-ui-pack/source_page.txt",
	"res://third_party/assets/kenney-pixel-ui-pack/metadata.json",
	"res://data/assets/asset_manifest.json",
	"res://data/locations/location_index.json",
	"res://data/locations/collapsed_bridge.json",
	"res://data/locations/old_ledge.json",
	"res://data/locations/stone_forest_stub.json",
	"res://data/locations/mine_entrance_stub.json",
	"res://data/dialogues/bridge_tutorial.json",
	"res://data/dialogues/tesa_intro.json",
	"res://data/dialogues/mark_on_skin.json",
	"res://data/dialogues/mine_entrance_notice.json",
	"res://data/quests/ash_under_skin.json",
	"res://scenes/boot/boot.tscn",
	"res://scenes/main/main.tscn",
	"res://scenes/main/title_screen.tscn",
	"res://scenes/player/player.tscn",
	"res://scenes/enemies/ash_mite.tscn",
	"res://scenes/enemies/petrified_wolf.tscn",
	"res://scenes/enemies/hollow_miner.tscn",
	"res://scenes/enemies/training_dummy.tscn",
	"res://scenes/npc/tesa.tscn",
	"res://scenes/ui/mobile_hud.tscn",
	"res://scenes/ui/pause_menu.tscn",
	"res://scenes/ui/dialogue_panel.tscn",
	"res://scenes/ui/inventory_panel.tscn",
	"res://scenes/ui/journal_panel.tscn",
	"res://scenes/ui/quest_update_panel.tscn",
	"res://scenes/locations/collapsed_bridge.tscn",
	"res://scenes/locations/old_ledge.tscn",
	"res://scenes/locations/stone_forest_stub.tscn",
	"res://scenes/locations/mine_entrance_stub.tscn",
	"res://tools/generate_placeholder_assets.gd",
	"res://tools/normalize_assets.gd",
	"res://tools/validate_asset_manifest.gd",
	"res://tools/validate_runtime_smoke.gd",
	"res://tools/validate_project_structure.gd",
	"res://tools/generate_test_world.gd",
]

const REQUIRED_DIRECTORIES := [
	"res://assets/generated/placeholders",
	"res://assets/runtime/characters",
	"res://assets/runtime/enemies",
	"res://assets/runtime/environment",
	"res://assets/runtime/tilesets",
	"res://assets/runtime/ui",
	"res://assets/runtime/items",
	"res://assets/runtime/effects",
	"res://assets/runtime/audio",
	"res://assets/runtime/fonts",
	"res://assets/source_cache",
	"res://credits",
	"res://data",
	"res://docs",
	"res://scenes",
	"res://scenes/components",
	"res://scripts",
	"res://resources",
	"res://resources/tilesets",
	"res://resources/themes",
	"res://resources/items",
	"res://resources/enemies",
	"res://resources/locations",
	"res://tests",
	"res://tools",
	"res://third_party",
	"res://third_party/assets",
]

const REQUIRED_PLACEHOLDERS := [
	"res://assets/generated/placeholders/PROCEDURAL_ORIGINALITY.txt",
	"res://assets/generated/placeholders/player_placeholder_atlas.png",
	"res://assets/generated/placeholders/ash_dol_tileset.png",
	"res://assets/generated/placeholders/ash_mite_placeholder_atlas.png",
	"res://assets/generated/placeholders/petrified_wolf_placeholder_atlas.png",
	"res://assets/generated/placeholders/hollow_miner_placeholder_atlas.png",
	"res://assets/generated/placeholders/training_dummy_placeholder_atlas.png",
	"res://assets/generated/placeholders/ui_placeholder_atlas.png",
	"res://assets/generated/placeholders/item_placeholder_atlas.png",
	"res://assets/generated/placeholders/fx_placeholder_atlas.png",
	"res://assets/generated/placeholders/npc_tessa_placeholder.png",
	"res://assets/generated/placeholders/missing_placeholder.png",
	"res://assets/generated/placeholders/dead_tree_placeholder.png",
	"res://assets/generated/placeholders/furnace_pipe_placeholder.png",
	"res://assets/generated/placeholders/lantern_placeholder.png",
	"res://assets/generated/placeholders/gate_placeholder.png",
	"res://assets/runtime/characters/player_placeholder_atlas.png",
	"res://assets/runtime/tilesets/ash_dol_tileset.png",
	"res://assets/runtime/enemies/ash_mite_placeholder_atlas.png",
	"res://assets/runtime/enemies/petrified_wolf_placeholder_atlas.png",
	"res://assets/runtime/enemies/hollow_miner_placeholder_atlas.png",
	"res://assets/runtime/enemies/training_dummy_placeholder_atlas.png",
	"res://assets/runtime/ui/ui_placeholder_atlas.png",
	"res://assets/runtime/items/item_placeholder_atlas.png",
	"res://assets/runtime/effects/fx_placeholder_atlas.png",
	"res://assets/runtime/characters/npc_tessa_placeholder.png",
	"res://assets/runtime/ui/missing_placeholder.png",
	"res://assets/runtime/environment/dead_tree_placeholder.png",
	"res://assets/runtime/environment/furnace_pipe_placeholder.png",
	"res://assets/runtime/environment/lantern_placeholder.png",
	"res://assets/runtime/environment/gate_placeholder.png",
]

const THIRD_PARTY_LICENSE_FILES := [
	"res://third_party/assets/kenney-pixel-ui-pack/License.txt",
	"res://third_party/assets/kenney-pixel-ui-pack/source_page.txt",
	"res://third_party/assets/kenney-pixel-ui-pack/metadata.json",
]

const FORBIDDEN_SCENE_TEXT_PATTERNS := [
	"third_party/assets/",
	"type=\"TileMap\"",
	"extends TileMap",
]

const FORBIDDEN_BINARY_SUFFIXES := [
	".cs",
	".gdextension",
	".aar",
	".jar",
	".so",
]


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var exit_code := 0
	exit_code = max(exit_code, _check_required_directories())
	exit_code = max(exit_code, _check_required_files())
	exit_code = max(exit_code, _check_placeholder_files())
	exit_code = max(exit_code, _check_third_party_license_files())
	exit_code = max(exit_code, _check_forbidden_patterns())
	exit_code = max(exit_code, _check_forbidden_file_suffixes())
	quit(exit_code)


func _check_required_directories() -> int:
	var exit_code := 0
	for path in REQUIRED_DIRECTORIES:
		if not _dir_exists(path):
			push_error("validate_project_structure: missing directory %s" % path)
			exit_code = 1
	return exit_code


func _check_required_files() -> int:
	var exit_code := 0
	for path in REQUIRED_FILES:
		if not FileAccess.file_exists(path):
			push_error("validate_project_structure: missing file %s" % path)
			exit_code = 1
	return exit_code


func _check_placeholder_files() -> int:
	var exit_code := 0
	for path in REQUIRED_PLACEHOLDERS:
		if not FileAccess.file_exists(path):
			push_error("validate_project_structure: missing placeholder %s" % path)
			exit_code = 1
	return exit_code


func _check_third_party_license_files() -> int:
	var exit_code := 0
	for path in THIRD_PARTY_LICENSE_FILES:
		if not FileAccess.file_exists(path):
			push_error("validate_project_structure: missing third-party proof file %s" % path)
			exit_code = 1
	return exit_code


func _check_forbidden_patterns() -> int:
	var exit_code := 0
	exit_code = max(exit_code, _scan_text_tree("res://scenes", FORBIDDEN_SCENE_TEXT_PATTERNS))
	exit_code = max(exit_code, _scan_text_tree("res://scripts", FORBIDDEN_SCENE_TEXT_PATTERNS))
	return exit_code


func _check_forbidden_file_suffixes() -> int:
	var exit_code := 0
	var files := _collect_files("res://", FORBIDDEN_BINARY_SUFFIXES)
	for path in files:
		push_error("validate_project_structure: forbidden file type present %s" % path)
		exit_code = 1
	return exit_code


func _scan_text_tree(root: String, patterns: Array) -> int:
	var exit_code := 0
	var files := _collect_files(root, [".gd", ".tscn"])
	for path in files:
		var text := _read_text(path)
		if text == "":
			continue
		for pattern in patterns:
			if text.find(String(pattern)) != -1:
				push_error("validate_project_structure: forbidden pattern '%s' found in %s" % [String(pattern), path])
				exit_code = 1
	return exit_code


func _collect_files(root: String, suffixes: Array) -> Array:
	var results: Array = []
	var dir := DirAccess.open(root)
	if dir == null:
		return results
	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		if name == "." or name == ".." or name.begins_with("."):
			name = dir.get_next()
			continue
		var full_path := _join_path(root, name)
		if dir.current_is_dir():
			results.append_array(_collect_files(full_path, suffixes))
		else:
			if suffixes.is_empty():
				results.append(full_path)
			else:
				for suffix in suffixes:
					if full_path.ends_with(String(suffix)):
						results.append(full_path)
						break
		name = dir.get_next()
	dir.list_dir_end()
	return results


func _read_text(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""
	return file.get_as_text()


func _dir_exists(path: String) -> bool:
	var absolute := ProjectSettings.globalize_path(path)
	return DirAccess.dir_exists_absolute(absolute)


func _join_path(base: String, child: String) -> String:
	if base.ends_with("/"):
		return base + child
	return base + "/" + child
