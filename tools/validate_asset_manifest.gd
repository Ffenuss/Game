extends SceneTree

const MANIFEST_PATH := "res://data/assets/asset_manifest.json"
const APPROVED_THIRD_PARTY_LICENSES := [
	"CC0 1.0",
	"Public Domain",
]
const LOCAL_LICENSE_NAME := "Original generated placeholder"


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var exit_code := 0
	if not FileAccess.file_exists(MANIFEST_PATH):
		push_error("validate_asset_manifest: missing manifest.")
		quit(1)
		return
	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	if file == null:
		push_error("validate_asset_manifest: unable to open manifest.")
		quit(1)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		push_error("validate_asset_manifest: manifest JSON is invalid.")
		quit(1)
		return
	var manifest: Dictionary = parsed as Dictionary
	var assets_variant: Variant = manifest.get("assets", manifest)
	if not (assets_variant is Dictionary):
		push_error("validate_asset_manifest: manifest assets block is invalid.")
		quit(1)
		return
	var assets: Dictionary = assets_variant
	if assets.is_empty():
		push_error("validate_asset_manifest: no assets were found in the manifest.")
		quit(1)
		return
	for asset_id_variant in assets.keys():
		exit_code = max(exit_code, _validate_record(String(asset_id_variant), assets[asset_id_variant]))
	if not assets.has("placeholder.missing"):
		push_error("validate_asset_manifest: fallback asset id placeholder.missing is missing.")
		exit_code = 1
	quit(exit_code)


func _validate_record(asset_id: String, record_variant: Variant) -> int:
	var exit_code := 0
	if not (record_variant is Dictionary):
		push_error("validate_asset_manifest: asset %s is not a dictionary." % asset_id)
		return 1
	var record: Dictionary = record_variant
	var required_fields := [
		"runtime_path",
		"source_filename",
		"source_page",
		"source_domain",
		"license_name",
		"license_proof_path",
		"attribution_required",
		"source_hash",
		"runtime_hash",
		"import_date",
		"processing_notes",
		"replacement_status",
		"usage_locations",
		"designation",
	]
	for field in required_fields:
		if not record.has(field):
			push_error("validate_asset_manifest: asset %s is missing field %s" % [asset_id, String(field)])
			exit_code = 1
	var runtime_path := String(record.get("runtime_path", ""))
	if runtime_path == "":
		push_error("validate_asset_manifest: asset %s has an empty runtime_path." % asset_id)
		exit_code = 1
	elif not runtime_path.begins_with("res://assets/runtime/"):
		push_error("validate_asset_manifest: asset %s runtime_path must stay under assets/runtime/: %s" % [asset_id, runtime_path])
		exit_code = 1
	elif not FileAccess.file_exists(runtime_path):
		push_error("validate_asset_manifest: runtime file missing for %s -> %s" % [asset_id, runtime_path])
		exit_code = 1
	if runtime_path.find("third_party/assets/") != -1:
		push_error("validate_asset_manifest: asset %s points directly at third-party content." % asset_id)
		exit_code = 1
	var source_domain := String(record.get("source_domain", ""))
	var license_name := String(record.get("license_name", ""))
	var license_proof_path := String(record.get("license_proof_path", ""))
	var attribution_required := bool(record.get("attribution_required", false))
	if license_proof_path == "" or not FileAccess.file_exists(license_proof_path):
		push_error("validate_asset_manifest: asset %s is missing archived license proof %s" % [asset_id, license_proof_path])
		exit_code = 1
	if source_domain == "local":
		if license_name != LOCAL_LICENSE_NAME:
			push_error("validate_asset_manifest: local asset %s has unexpected license %s" % [asset_id, license_name])
			exit_code = 1
	else:
		if not APPROVED_THIRD_PARTY_LICENSES.has(license_name):
			push_error("validate_asset_manifest: third-party asset %s uses unsupported license %s" % [asset_id, license_name])
			exit_code = 1
		if attribution_required:
			push_error("validate_asset_manifest: third-party asset %s unexpectedly requires attribution." % asset_id)
			exit_code = 1
	var source_hash := String(record.get("source_hash", ""))
	var runtime_hash := String(record.get("runtime_hash", ""))
	if source_hash == "" or runtime_hash == "":
		push_error("validate_asset_manifest: asset %s is missing hash data." % asset_id)
		exit_code = 1
	if record.has("region"):
		var region_variant: Variant = record.get("region")
		if not (region_variant is Array):
			push_error("validate_asset_manifest: asset %s region is not an array." % asset_id)
			exit_code = 1
		else:
			var region: Array = region_variant
			if region.size() != 4:
				push_error("validate_asset_manifest: asset %s region must have four numbers." % asset_id)
				exit_code = 1
	var usage_locations_variant: Variant = record.get("usage_locations", [])
	if not (usage_locations_variant is Array) or usage_locations_variant.is_empty():
		push_error("validate_asset_manifest: asset %s must list at least one usage location." % asset_id)
		exit_code = 1
	return exit_code
