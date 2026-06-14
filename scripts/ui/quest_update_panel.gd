extends Control
class_name QuestUpdatePanel

@onready var background: Node = $Panel
@onready var label: Label = $Panel/Label

var _timer: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	background.set("texture", AssetCatalog.texture("ui.panel.quest"))


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
