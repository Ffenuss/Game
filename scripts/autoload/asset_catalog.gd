extends Node

const MANIFEST_PATH := "res://data/assets/asset_manifest.json"
const FALLBACK_ASSET_ID := "placeholder.missing"

var _manifest: Dictionary = {}
var _manifest_meta: Dictionary = {}
var _texture_cache: Dictionary = {}


func _ready() -> void:
	load_manifest()


func load_manifest() -> void:
	_manifest = {}
	if not FileAccess.file_exists(MANIFEST_PATH):
		push_warning("AssetCatalog: manifest missing at %s" % MANIFEST_PATH)
		return
	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	if file == null:
		push_warning("AssetCatalog: unable to open manifest.")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		push_warning("AssetCatalog: manifest is not valid JSON.")
		return
	_manifest_meta = parsed as Dictionary
	var assets_variant: Variant = _manifest_meta.get("assets", _manifest_meta)
	if assets_variant is Dictionary:
		_manifest = assets_variant
	else:
		_manifest = _manifest_meta


func has_asset(asset_id: String) -> bool:
	return _manifest.has(asset_id)


func get_record(asset_id: String) -> Dictionary:
	if _manifest.has(asset_id) and _manifest[asset_id] is Dictionary:
		return _manifest[asset_id]
	if _manifest.has(FALLBACK_ASSET_ID) and _manifest[FALLBACK_ASSET_ID] is Dictionary:
		return _manifest[FALLBACK_ASSET_ID]
	push_warning("AssetCatalog: falling back for missing asset id %s" % asset_id)
	return {}


func resolve_path(asset_id: String) -> String:
	var record := get_record(asset_id)
	return String(record.get("runtime_path", ""))


func texture(asset_id: String) -> Texture2D:
	if _texture_cache.has(asset_id):
		return _texture_cache[asset_id]
	var record := get_record(asset_id)
	var path := String(record.get("runtime_path", ""))
	if path == "":
		return null
	if record.has("region"):
		var atlas := _load_texture(path)
		if atlas == null:
			return null
		var region_data: Array = record.get("region", [])
		if region_data.size() < 4:
			return atlas
		var atlas_texture := AtlasTexture.new()
		atlas_texture.atlas = atlas
		atlas_texture.region = Rect2(
			float(region_data[0]),
			float(region_data[1]),
			float(region_data[2]),
			float(region_data[3])
		)
		_texture_cache[asset_id] = atlas_texture
		return atlas_texture
	var texture := _load_texture(path)
	_texture_cache[asset_id] = texture
	return texture


func _load_texture(path: String) -> Texture2D:
	var lower_path := path.to_lower()
	if lower_path.ends_with(".png") or lower_path.ends_with(".jpg") or lower_path.ends_with(".jpeg") or lower_path.ends_with(".webp"):
		var image := Image.load_from_file(path)
		if image != null and not image.is_empty():
			return ImageTexture.create_from_image(image)

	var texture := load(path) as Texture2D
	if texture != null:
		return texture

	push_warning("AssetCatalog: runtime asset missing: %s" % path)
	var fallback_path := resolve_path(FALLBACK_ASSET_ID)
	if fallback_path != "":
		var fallback_lower := fallback_path.to_lower()
		if fallback_lower.ends_with(".png") or fallback_lower.ends_with(".jpg") or fallback_lower.ends_with(".jpeg") or fallback_lower.ends_with(".webp"):
			var fallback_image := Image.load_from_file(fallback_path)
			if fallback_image != null and not fallback_image.is_empty():
				return ImageTexture.create_from_image(fallback_image)
		var fallback_texture := load(fallback_path) as Texture2D
		if fallback_texture != null:
			return fallback_texture
	return null


func list_ids() -> PackedStringArray:
	var ids := PackedStringArray()
	for key in _manifest.keys():
		ids.append(String(key))
	return ids
