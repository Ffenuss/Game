extends Node

signal checkpoint_changed(checkpoint_id: String, respawn_position: Vector2)
signal location_changed(location_id: String)
signal player_registered(player: Node)
signal player_cleared()
signal dialogue_requested(dialogue_id: String, speaker_name: String)
signal pause_requested()
signal inventory_changed()
signal quest_state_changed(quest_id: String, objective: String)
signal interaction_prompt_changed(visible: bool, prompt_text: String)

var current_location_id: String = ""
var current_location_name: String = ""
var current_location_scene_path: String = ""
var respawn_location_id: String = ""
var current_checkpoint_id: String = ""
var respawn_position: Vector2 = Vector2.ZERO
var movement_override: Vector2 = Vector2.ZERO
var current_player: Node = null
var ui_locked: bool = false
var interaction_prompt_visible: bool = false
var interaction_prompt_text: String = ""

var settings: Dictionary = {
	"effects_low": false,
	"music_volume": 0.8,
	"sfx_volume": 0.8,
	"language": "ru",
}

var player_snapshot: Dictionary = {}
var inventory_snapshot: Array[Dictionary] = []
var save_version: int = 1


func set_location(location_id: String, display_name: String = "", scene_path: String = "") -> void:
	current_location_id = location_id
	if display_name != "":
		current_location_name = display_name
	if scene_path != "":
		current_location_scene_path = scene_path
	emit_signal("location_changed", location_id)


func set_checkpoint(checkpoint_id: String, position: Vector2, location_id: String = "") -> void:
	current_checkpoint_id = checkpoint_id
	respawn_position = position
	if location_id != "":
		respawn_location_id = location_id
	elif current_location_id != "":
		respawn_location_id = current_location_id
	emit_signal("checkpoint_changed", checkpoint_id, position)


func register_player(player: Node) -> void:
	current_player = player
	emit_signal("player_registered", player)


func clear_player() -> void:
	current_player = null
	movement_override = Vector2.ZERO
	set_interaction_prompt(false, "")
	emit_signal("player_cleared")


func set_movement_override(direction: Vector2) -> void:
	movement_override = direction


func get_movement_vector() -> Vector2:
	if movement_override.length_squared() > 0.001:
		return movement_override.limit_length(1.0)
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")


func request_dialogue(dialogue_id: String, speaker_name: String) -> void:
	emit_signal("dialogue_requested", dialogue_id, speaker_name)


func request_pause() -> void:
	emit_signal("pause_requested")


func set_interaction_prompt(visible: bool, prompt_text: String = "") -> void:
	interaction_prompt_visible = visible
	interaction_prompt_text = prompt_text
	emit_signal("interaction_prompt_changed", visible, prompt_text)


func notify_quest_objective(quest_id: String, objective: String) -> void:
	emit_signal("quest_state_changed", quest_id, objective)


func remember_player_snapshot(snapshot: Dictionary) -> void:
	player_snapshot = snapshot.duplicate(true)


func remember_inventory_snapshot(snapshot: Array) -> void:
	inventory_snapshot = snapshot.duplicate(true)
	emit_signal("inventory_changed")


func get_inventory_entry_index(item_id: String) -> int:
	for index in inventory_snapshot.size():
		var entry_variant: Variant = inventory_snapshot[index]
		if not (entry_variant is Dictionary):
			continue
		var entry: Dictionary = entry_variant
		if String(entry.get("id", "")) == item_id:
			return index
	return -1


func get_inventory_entry(item_id: String) -> Dictionary:
	var index := get_inventory_entry_index(item_id)
	if index < 0:
		return {}
	var entry_variant: Variant = inventory_snapshot[index]
	if entry_variant is Dictionary:
		return (entry_variant as Dictionary).duplicate(true)
	return {}


func add_inventory_item(item_id: String, quantity: int = 1, metadata: Dictionary = {}) -> void:
	if item_id.strip_edges() == "" or quantity <= 0:
		return
	var index := get_inventory_entry_index(item_id)
	var entry: Dictionary = {}
	if index >= 0:
		var existing_variant: Variant = inventory_snapshot[index]
		if existing_variant is Dictionary:
			entry = (existing_variant as Dictionary).duplicate(true)
	else:
		entry = metadata.duplicate(true)
	entry["id"] = item_id
	entry["quantity"] = int(entry.get("quantity", 0)) + quantity
	for key in metadata.keys():
		if not entry.has(key) or String(entry.get(key, "")).strip_edges() == "":
			entry[key] = metadata[key]
	if index >= 0:
		inventory_snapshot[index] = entry
	else:
		inventory_snapshot.append(entry)
	emit_signal("inventory_changed")


func consume_inventory_item(item_id: String, quantity: int = 1) -> bool:
	if item_id.strip_edges() == "" or quantity <= 0:
		return false
	var index := get_inventory_entry_index(item_id)
	if index < 0:
		return false
	var entry_variant: Variant = inventory_snapshot[index]
	if not (entry_variant is Dictionary):
		return false
	var entry: Dictionary = (entry_variant as Dictionary).duplicate(true)
	var current_quantity := int(entry.get("quantity", 1))
	if current_quantity < quantity:
		return false
	current_quantity -= quantity
	if current_quantity <= 0:
		inventory_snapshot.remove_at(index)
	else:
		entry["quantity"] = current_quantity
		inventory_snapshot[index] = entry
	emit_signal("inventory_changed")
	return true


func build_snapshot() -> Dictionary:
	return {
		"version": save_version,
		"location_id": current_location_id,
		"location_name": current_location_name,
		"scene_path": current_location_scene_path,
		"checkpoint_id": current_checkpoint_id,
		"respawn_location_id": respawn_location_id,
		"respawn_position": [respawn_position.x, respawn_position.y],
		"settings": settings.duplicate(true),
		"player": player_snapshot.duplicate(true),
		"inventory": inventory_snapshot.duplicate(true),
	}


func apply_snapshot(data: Dictionary) -> void:
	settings = data.get("settings", settings).duplicate(true)
	player_snapshot = data.get("player", player_snapshot).duplicate(true)
	var location_id := String(data.get("location_id", current_location_id))
	var location_name := String(data.get("location_name", current_location_name))
	var scene_path := String(data.get("scene_path", current_location_scene_path))
	set_location(location_id, location_name, scene_path)
	current_checkpoint_id = String(data.get("checkpoint_id", current_checkpoint_id))
	respawn_location_id = String(data.get("respawn_location_id", respawn_location_id))
	var respawn_array: Array = data.get("respawn_position", [respawn_position.x, respawn_position.y])
	if respawn_array.size() >= 2:
		respawn_position = Vector2(float(respawn_array[0]), float(respawn_array[1]))
	var inventory_data: Array = data.get("inventory", [])
	inventory_snapshot = []
	for entry in inventory_data:
		if entry is Dictionary:
			inventory_snapshot.append(entry)
	emit_signal("inventory_changed")
