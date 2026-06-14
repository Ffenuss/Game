extends Node
class_name MainRoot

@onready var world_host: Node2D = $WorldHost
@onready var ui_layer: CanvasLayer = $UILayer
@onready var mobile_hud: MobileHud = $UILayer/MobileHud
@onready var pause_menu: PauseMenu = $UILayer/PauseMenu
@onready var dialogue_panel: DialoguePanel = $UILayer/DialoguePanel
@onready var inventory_panel: InventoryPanel = $UILayer/InventoryPanel
@onready var journal_panel: JournalPanel = $UILayer/JournalPanel
@onready var quest_toast: QuestUpdatePanel = $UILayer/QuestUpdatePanel


func _ready() -> void:
	SceneRouter.register_world_host(world_host)
	GameState.pause_requested.connect(_on_pause_requested)
	GameState.dialogue_requested.connect(_on_dialogue_requested)
	GameState.player_registered.connect(_on_player_registered)
	GameState.player_cleared.connect(_on_player_cleared)
	GameState.inventory_changed.connect(_refresh_inventory)
	GameState.interaction_prompt_changed.connect(_on_interaction_prompt_changed)
	QuestManager.quest_changed.connect(_on_quest_changed)
	QuestManager.journal_updated.connect(_refresh_journal)
	pause_menu.resume_requested.connect(_resume_game)
	pause_menu.restart_requested.connect(_restart_checkpoint)
	pause_menu.main_menu_requested.connect(_return_to_title)
	pause_menu.inventory_requested.connect(_show_inventory)
	pause_menu.journal_requested.connect(_show_journal)
	dialogue_panel.closed.connect(_on_dialogue_closed)
	dialogue_panel.advance_requested.connect(_on_dialogue_advance_requested)
	if GameState.current_location_id == "":
		GameState.current_location_id = "collapsed_bridge"
	SceneRouter.load_location(GameState.current_location_id)
	_refresh_inventory()
	_refresh_journal()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_inventory"):
		_toggle_inventory()
	if Input.is_action_just_pressed("open_journal"):
		_toggle_journal()


func _on_player_registered(player: Node) -> void:
	mobile_hud.bind_player(player)


func _on_player_cleared() -> void:
	mobile_hud.clear_player()


func _on_interaction_prompt_changed(visible: bool, prompt_text: String) -> void:
	mobile_hud.set_interaction_prompt(visible, prompt_text)


func _on_pause_requested() -> void:
	_open_pause_menu()


func _on_dialogue_requested(dialogue_id: String, speaker_name: String) -> void:
	_open_dialogue(dialogue_id, speaker_name)


func _on_dialogue_closed() -> void:
	_resume_game()


func _on_dialogue_advance_requested() -> void:
	pass


func _on_quest_changed(_quest_id: String, _stage_index: int, objective: String) -> void:
	quest_toast.show_update(objective)
	_refresh_journal()


func _refresh_journal() -> void:
	journal_panel.refresh()


func _refresh_inventory() -> void:
	inventory_panel.refresh()


func _open_pause_menu() -> void:
	get_tree().paused = true
	pause_menu.visible = true
	pause_menu.open()


func _resume_game() -> void:
	get_tree().paused = false
	pause_menu.close()
	dialogue_panel.force_close()
	inventory_panel.hide_panel()
	journal_panel.hide_panel()


func _restart_checkpoint() -> void:
	get_tree().paused = false
	if not SaveManager.load_game():
		push_warning("MainRoot: no save available to restore checkpoint.")
	SceneRouter.reload_current_location()
	pause_menu.close()


func _return_to_title() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/title_screen.tscn")


func _show_inventory() -> void:
	journal_panel.hide_panel()
	inventory_panel.toggle_panel()


func _show_journal() -> void:
	inventory_panel.hide_panel()
	journal_panel.toggle_panel()


func _toggle_inventory() -> void:
	journal_panel.hide_panel()
	inventory_panel.toggle_panel()


func _toggle_journal() -> void:
	inventory_panel.hide_panel()
	journal_panel.toggle_panel()


func _open_dialogue(dialogue_id: String, speaker_name: String) -> void:
	get_tree().paused = true
	dialogue_panel.show_dialogue(dialogue_id, speaker_name)
