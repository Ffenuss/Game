extends Control
class_name DialoguePanel

signal closed()
signal advance_requested()

@onready var background: Node = $Panel
@onready var speaker_label: Label = $Panel/VBox/SpeakerLabel
@onready var body_label: RichTextLabel = $Panel/VBox/BodyLabel
@onready var portrait: TextureRect = $Panel/VBox/Header/Portrait
@onready var continue_button: Button = $Panel/VBox/ContinueButton
@onready var choice_container: VBoxContainer = $Panel/VBox/Choices

var _dialogue_data: Dictionary = {}
var _line_index: int = 0
var _reveal_speed: float = 90.0
var _current_text: String = ""
var _revealed_characters: int = 0
var _is_revealing: bool = false
var _speaker_override: String = ""


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	continue_button.text = "Дальше"
	continue_button.pressed.connect(_on_continue_pressed)
	_set_skin()


func _process(delta: float) -> void:
	if not visible:
		return
	if _is_revealing:
		_revealed_characters = min(_current_text.length(), _revealed_characters + int(_reveal_speed * delta))
		body_label.visible_characters = _revealed_characters
		if _revealed_characters >= _current_text.length():
			_is_revealing = false


func show_dialogue(dialogue_id: String, speaker_name: String = "") -> void:
	_dialogue_data = _load_dialogue(dialogue_id)
	_speaker_override = speaker_name
	_line_index = 0
	visible = true
	choice_container.visible = false
	_refresh_line()


func close() -> void:
	visible = false
	_dialogue_data = {}
	_current_text = ""
	choice_container.visible = false
	emit_signal("closed")


func force_close() -> void:
	visible = false
	_dialogue_data = {}
	_current_text = ""
	choice_container.visible = false


func _on_continue_pressed() -> void:
	if not visible:
		return
	if _is_revealing:
		_revealed_characters = _current_text.length()
		body_label.visible_characters = -1
		_is_revealing = false
		return
	_line_index += 1
	if _line_index >= _get_lines().size():
		_apply_dialogue_completion()
		close()
		return
	_refresh_line()


func _refresh_line() -> void:
	var lines := _get_lines()
	if lines.is_empty():
		_current_text = ""
		body_label.text = ""
		return
	var line_data: Variant = lines[_line_index]
	if line_data is Dictionary:
		var line: Dictionary = line_data
		speaker_label.text = _speaker_text(line)
		_current_text = String(line.get("text", ""))
		_apply_portrait(line)
	else:
		speaker_label.text = _speaker_override if _speaker_override != "" else String(_dialogue_data.get("speaker", ""))
		_current_text = String(line_data)
	body_label.text = _current_text
	body_label.visible_characters = 0
	_revealed_characters = 0
	_is_revealing = true


func _get_lines() -> Array:
	var lines: Array = _dialogue_data.get("lines", [])
	return lines


func _speaker_text(line: Dictionary) -> String:
	var override := _speaker_override
	if override != "":
		return override
	return String(line.get("speaker", _dialogue_data.get("speaker", "")))


func _apply_portrait(line: Dictionary) -> void:
	var portrait_id := String(line.get("portrait", _dialogue_data.get("portrait", "")))
	if portrait_id == "":
		portrait.texture = null
		return
	portrait.texture = AssetCatalog.texture(portrait_id)


func _load_dialogue(dialogue_id: String) -> Dictionary:
	var path := "res://data/dialogues/%s.json" % dialogue_id
	if not FileAccess.file_exists(path):
		push_warning("DialoguePanel: missing dialogue data %s" % path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		return parsed as Dictionary
	return {}


func _apply_dialogue_completion() -> void:
	var quest_data: Dictionary = _dialogue_data.get("quest", {})
	if quest_data.is_empty():
		return
	var quest_id := String(quest_data.get("quest_id", ""))
	var stage_index := int(quest_data.get("stage_index", 0))
	if quest_id != "" and stage_index > 0:
		QuestManager.active_quest_id = quest_id
		QuestManager.set_stage(stage_index)


func _set_skin() -> void:
	background.set("texture", AssetCatalog.texture("ui.panel.dialogue"))
