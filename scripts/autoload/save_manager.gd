extends Node

signal save_finished(success: bool, path: String)
signal load_finished(success: bool, path: String)

const SAVE_PATH := "user://save_slot_1.json"
const SAVE_VERSION := 1


func save_game(reason: String = "manual") -> bool:
	var data := GameState.build_snapshot()
	data["reason"] = reason
	if QuestManager.has_method("export_save_data"):
		data["quests"] = QuestManager.export_save_data()
	var json_text := JSON.stringify(data, "\t")
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: unable to open save file for writing: %s" % SAVE_PATH)
		emit_signal("save_finished", false, SAVE_PATH)
		return false
	file.store_string(json_text)
	file.flush()
	emit_signal("save_finished", true, SAVE_PATH)
	return true


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		emit_signal("load_finished", false, SAVE_PATH)
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("SaveManager: unable to open save file for reading: %s" % SAVE_PATH)
		emit_signal("load_finished", false, SAVE_PATH)
		return false
	var json_text := file.get_as_text()
	var parsed: Variant = JSON.parse_string(json_text)
	if not (parsed is Dictionary):
		push_warning("SaveManager: save file was corrupt or empty, resetting to defaults.")
		emit_signal("load_finished", false, SAVE_PATH)
		return false
	var data: Dictionary = parsed
	GameState.apply_snapshot(data)
	if QuestManager.has_method("apply_save_data"):
		QuestManager.apply_save_data(data.get("quests", {}))
	emit_signal("load_finished", true, SAVE_PATH)
	return true


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))


func autosave(reason: String = "checkpoint") -> void:
	save_game(reason)
