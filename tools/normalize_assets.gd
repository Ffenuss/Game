extends SceneTree

const MANIFEST_PATH := "res://data/assets/asset_manifest.json"


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if not FileAccess.file_exists(MANIFEST_PATH):
		push_error("normalize_assets: manifest missing.")
		quit(1)
		return
	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	if file == null:
		push_error("normalize_assets: unable to open manifest.")
		quit(1)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	var asset_count := 0
	if parsed is Dictionary:
		var manifest: Dictionary = parsed as Dictionary
		var assets_variant: Variant = manifest.get("assets", manifest)
		if assets_variant is Dictionary:
			var assets: Dictionary = assets_variant
			asset_count = assets.size()
	print("Asset normalization hook ready for %d manifest assets." % asset_count)
	quit(0)
