extends SceneTree

const LOCATION_FILES := [
	"res://data/locations/collapsed_bridge.json",
	"res://data/locations/old_ledge.json",
	"res://data/locations/stone_forest_stub.json",
	"res://data/locations/mine_entrance_stub.json",
]


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var summary := PackedStringArray()
	for path in LOCATION_FILES:
		if not FileAccess.file_exists(path):
			push_warning("generate_test_world: missing location file %s" % path)
			continue
		var file := FileAccess.open(path, FileAccess.READ)
		if file == null:
			push_warning("generate_test_world: unable to read %s" % path)
			continue
		var parsed: Variant = JSON.parse_string(file.get_as_text())
		if parsed is Dictionary:
			var data: Dictionary = parsed as Dictionary
			var entities: Array = data.get("entities", [])
			summary.append("%s (%s, %d entities)" % [
				path.get_file(),
				String(data.get("display_name", path)),
				entities.size()
			])
	print("Generate test world hook ready:")
	for line in summary:
		print(" - %s" % line)
	quit(0)
