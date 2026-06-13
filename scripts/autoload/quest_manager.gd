extends Node

signal quest_changed(quest_id: String, stage_index: int, objective: String)
signal journal_updated()

const DEFAULT_QUEST_ID := "ash_under_skin"
const QUEST_DATA_PATH := "res://data/quests/ash_under_skin.json"

var quest_data: Dictionary = {}
var active_quest_id: String = DEFAULT_QUEST_ID
var active_stage_index: int = 0
var completed_quests: Array[String] = []
var quest_flags: Dictionary = {}


func _ready() -> void:
	load_quest_data()
	if active_stage_index <= 0:
		active_stage_index = 1
	emit_current_state()


func load_quest_data() -> void:
	quest_data = {}
	if not FileAccess.file_exists(QUEST_DATA_PATH):
		push_warning("QuestManager: quest data missing at %s" % QUEST_DATA_PATH)
		return
	var file := FileAccess.open(QUEST_DATA_PATH, FileAccess.READ)
	if file == null:
		push_warning("QuestManager: unable to open quest data.")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		quest_data = parsed as Dictionary
	else:
		push_warning("QuestManager: quest data JSON was invalid.")


func get_active_quest() -> Dictionary:
	if quest_data.is_empty():
		return {}
	if quest_data.get("id", DEFAULT_QUEST_ID) != active_quest_id:
		return quest_data
	return quest_data


func get_active_objective() -> String:
	var stages_variant: Variant = quest_data.get("stages", [])
	if not (stages_variant is Array):
		return ""
	var stages: Array = stages_variant
	if stages.is_empty():
		return ""
	var index: int = clamp(active_stage_index - 1, 0, stages.size() - 1)
	var stage_variant: Variant = stages[index]
	if stage_variant is Dictionary:
		var stage: Dictionary = stage_variant
		return String(stage.get("objective", ""))
	return ""


func set_stage(stage_index: int) -> void:
	active_stage_index = max(1, stage_index)
	emit_current_state()


func advance_stage() -> void:
	set_stage(active_stage_index + 1)


func complete_quest() -> void:
	if not completed_quests.has(active_quest_id):
		completed_quests.append(active_quest_id)
	emit_signal("journal_updated")


func set_flag(flag_name: String, value: Variant) -> void:
	quest_flags[flag_name] = value
	emit_signal("journal_updated")


func get_flag(flag_name: String, default_value: Variant = null) -> Variant:
	return quest_flags.get(flag_name, default_value)


func emit_current_state() -> void:
	emit_signal("quest_changed", active_quest_id, active_stage_index, get_active_objective())
	emit_signal("journal_updated")
	GameState.notify_quest_objective(active_quest_id, get_active_objective())


func apply_save_data(data: Dictionary) -> void:
	active_quest_id = String(data.get("active_quest_id", DEFAULT_QUEST_ID))
	active_stage_index = int(data.get("active_stage_index", 1))
	completed_quests = []
	for quest_id in data.get("completed_quests", []):
		completed_quests.append(String(quest_id))
	var quest_flags_variant: Variant = data.get("quest_flags", {})
	if quest_flags_variant is Dictionary:
		quest_flags = (quest_flags_variant as Dictionary).duplicate(true)
	else:
		quest_flags = {}
	if active_stage_index <= 0:
		active_stage_index = 1
	emit_current_state()


func export_save_data() -> Dictionary:
	return {
		"active_quest_id": active_quest_id,
		"active_stage_index": active_stage_index,
		"completed_quests": completed_quests.duplicate(true),
		"quest_flags": quest_flags.duplicate(true),
	}
