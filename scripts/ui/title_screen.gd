extends Control
class_name TitleScreen

const UI_STYLE_SCRIPT := preload("res://scripts/ui/ui_style.gd")

@onready var panel: NinePatchRect = $Panel
@onready var title_label: Label = $Panel/VBox/TitleLabel
@onready var subtitle_label: Label = $Panel/VBox/SubtitleLabel
@onready var new_game_button: Button = $Panel/VBox/NewGameButton
@onready var continue_button: Button = $Panel/VBox/ContinueButton
@onready var credits_button: Button = $Panel/VBox/CreditsButton

var _ui_style := UI_STYLE_SCRIPT.new()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	title_label.text = "Пепельный Дол"
	subtitle_label.text = "Клеймо Пустоши"
	new_game_button.text = "Новая игра"
	continue_button.text = "Продолжить"
	credits_button.text = "Авторы"
	new_game_button.pressed.connect(_start_new_game)
	continue_button.pressed.connect(_continue_game)
	credits_button.pressed.connect(_show_credits)
	continue_button.disabled = not SaveManager.has_save()
	_ui_style.apply_panel(panel, "ui.panel.title", 0.96)
	_ui_style.apply_label(title_label, 21, _ui_style.FONT_PRIMARY, true)
	_ui_style.apply_label(subtitle_label, 13, _ui_style.FONT_SECONDARY, true)
	_ui_style.apply_button(new_game_button, _ui_style.ACCENT_FIRE, 11)
	_ui_style.apply_button(continue_button, _ui_style.ACCENT_FOG, 11)
	_ui_style.apply_button(credits_button, _ui_style.ACCENT_ASH, 11)
	_set_skin()


func _start_new_game() -> void:
	GameState.player_snapshot = {}
	GameState.remember_inventory_snapshot([])
	GameState.add_inventory_item("rusty_knife", 1)
	GameState.add_inventory_item("healing_herb", 2)
	GameState.current_checkpoint_id = ""
	GameState.respawn_location_id = ""
	GameState.respawn_position = Vector2.ZERO
	GameState.clear_player()
	GameState.current_location_id = "collapsed_bridge"
	GameState.current_location_name = ""
	GameState.current_location_scene_path = ""
	GameState.settings["equipped_item_id"] = "rusty_knife"
	QuestManager.active_quest_id = "ash_under_skin"
	QuestManager.set_stage(1)
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _continue_game() -> void:
	if not SaveManager.load_game():
		_start_new_game()
		return
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _show_credits() -> void:
	subtitle_label.text = "Ассеты CC0 и оригинальные заглушки."


func _set_skin() -> void:
	var panel := get_node_or_null("Panel")
	if panel != null:
		panel.set("texture", AssetCatalog.texture("ui.panel.title"))
