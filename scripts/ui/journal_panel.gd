extends Control
class_name JournalPanel

const UI_STYLE_SCRIPT := preload("res://scripts/ui/ui_style.gd")

@onready var background: Node = $Panel
@onready var title_label: Label = $Panel/VBox/TitleLabel
@onready var quest_label: Label = $Panel/VBox/QuestLabel
@onready var objective_label: RichTextLabel = $Panel/VBox/ObjectiveLabel
@onready var completed_label: RichTextLabel = $Panel/VBox/CompletedLabel
@onready var close_button: Button = $Panel/VBox/Buttons/CloseButton

var _ui_style := UI_STYLE_SCRIPT.new()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	title_label.text = "Журнал"
	close_button.text = "Закрыть"
	close_button.pressed.connect(hide_panel)
	_ui_style.apply_panel(background as NinePatchRect, "ui.panel.journal", 0.94)
	_ui_style.apply_label(title_label, 17, _ui_style.FONT_PRIMARY, true)
	_ui_style.apply_label(quest_label, 12, _ui_style.FONT_SECONDARY)
	_ui_style.apply_rich_label(objective_label, _ui_style.FONT_SECONDARY)
	_ui_style.apply_rich_label(completed_label, _ui_style.FONT_SECONDARY)
	_ui_style.apply_button(close_button, _ui_style.ACCENT_ASH, 11)
	refresh()


func toggle_panel() -> void:
	visible = not visible
	if visible:
		refresh()


func hide_panel() -> void:
	visible = false


func refresh() -> void:
	title_label.text = "Журнал"
	quest_label.text = "Активный квест: %s" % QuestManager.get_active_title()
	objective_label.text = "Текущее задание:\n%s" % QuestManager.get_active_objective()
	if QuestManager.completed_quests.is_empty():
		completed_label.text = "Завершённые записи появятся позже."
	else:
		completed_label.text = "Завершённые:\n- " + "\n- ".join(QuestManager.completed_quests)
