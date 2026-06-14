extends Control
class_name QuestUpdatePanel

const UI_STYLE_SCRIPT := preload("res://scripts/ui/ui_style.gd")

@onready var background: Node = $Panel
@onready var label: Label = $Panel/Label

var _ui_style := UI_STYLE_SCRIPT.new()

var _timer: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	_ui_style.apply_panel(background as NinePatchRect, "ui.panel.quest", 0.90)
	_ui_style.apply_label(label, 11, _ui_style.FONT_PRIMARY, true)


func _process(delta: float) -> void:
	if not visible:
		return
	_timer -= delta
	if _timer <= 0.0:
		visible = false


func show_update(text: String) -> void:
	if text.strip_edges() == "":
		return
	label.text = text
	_timer = 2.8
	visible = true
