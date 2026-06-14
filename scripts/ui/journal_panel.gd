extends Control
class_name JournalPanel

@onready var background: Node = $Panel
@onready var title_label: Label = $Panel/VBox/TitleLabel
@onready var quest_label: Label = $Panel/VBox/QuestLabel
@onready var objective_label: RichTextLabel = $Panel/VBox/ObjectiveLabel
@onready var completed_label: RichTextLabel = $Panel/VBox/CompletedLabel
@onready var close_button: Button = $Panel/VBox/Buttons/CloseButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	title_label.text = "Журнал"
	close_button.text = "Закрыть"
	close_button.pressed.connect(hide_panel)
	background.set("texture", AssetCatalog.texture("ui.panel.journal"))
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
