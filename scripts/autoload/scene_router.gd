extends Node

signal location_loaded(location_id: String, location_root: Node)

const LOCATION_INDEX_PATH := "res://data/locations/location_index.json"

var _world_host: Node = null
var _current_location_root: Node = null
var _current_location_id: String = ""
var _location_index: Dictionary = {}


func _ready() -> void:
	_load_location_index()


func register_world_host(world_host: Node) -> void:
	_world_host = world_host


func _load_location_index() -> void:
	_location_index = {}
	if not FileAccess.file_exists(LOCATION_INDEX_PATH):
		push_warning("SceneRouter: location index missing at %s" % LOCATION_INDEX_PATH)
		return
	var file := FileAccess.open(LOCATION_INDEX_PATH, FileAccess.READ)
	if file == null:
		push_warning("SceneRouter: unable to open location index.")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		_location_index = parsed as Dictionary


func load_location(location_id: String) -> Node:
	if _world_host == null:
		push_warning("SceneRouter: world host not registered.")
		return null
	_clear_current_location()
	var scene_path := String(_location_index.get(location_id, ""))
	if scene_path == "":
		push_warning("SceneRouter: unknown location id %s" % location_id)
		return null
	if not ResourceLoader.exists(scene_path):
		push_error("SceneRouter: location scene missing: %s" % scene_path)
		return null
	var packed := load(scene_path) as PackedScene
	if packed == null:
		push_error("SceneRouter: failed to load location scene: %s" % scene_path)
		return null
	var location_root := packed.instantiate()
	_world_host.add_child(location_root)
	_current_location_root = location_root
	_current_location_id = location_id
	GameState.set_location(location_id, "", scene_path)
	emit_signal("location_loaded", location_id, location_root)
	return location_root


func reload_current_location() -> Node:
	if _current_location_id == "":
		return null
	return load_location(_current_location_id)


func get_current_location_root() -> Node:
	return _current_location_root


func get_current_location_id() -> String:
	return _current_location_id


func _clear_current_location() -> void:
	GameState.clear_player()
	if _current_location_root != null and is_instance_valid(_current_location_root):
		_current_location_root.queue_free()
	_current_location_root = null
