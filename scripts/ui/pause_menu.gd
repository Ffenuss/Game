extends Control
class_name PauseMenu

const UI_STYLE_SCRIPT := preload("res://scripts/ui/ui_style.gd")

signal resume_requested()
signal restart_requested()
signal main_menu_requested()
signal inventory_requested()
signal journal_requested()

@onready var background: Node = $Panel
@onready var continue_button: Button = $Panel/Buttons/ContinueButton
@onready var inventory_button: Button = $Panel/Buttons/InventoryButton
@onready var journal_button: Button = $Panel/Buttons/JournalButton
@onready var settings_button: Button = $Panel/Buttons/SettingsButton
@onready var restart_button: Button = $Panel/Buttons/RestartButton
@onready var main_menu_button: Button = $Panel/Buttons/MainMenuButton
@onready var title_label: Label = $Panel/TitleLabel

var _ui_style := UI_STYLE_SCRIPT.new()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = false
	title_label.text = "Пауза"
	continue_button.text = "Продолжить"
	inventory_button.text = "Инвентарь"
	journal_button.text = "Журнал"
	settings_button.text = "Настройки"
	restart_button.text = "Перезапустить с контрольной точки"
	main_menu_button.text = "В главное меню"
	continue_button.pressed.connect(_emit_resume)
	inventory_button.pressed.connect(func() -> void:
		emit_signal("inventory_requested")
	)
	journal_button.pressed.connect(func() -> void:
		emit_signal("journal_requested")
	)
	settings_button.pressed.connect(_show_settings_placeholder)
	restart_button.pressed.connect(func() -> void:
		emit_signal("restart_requested")
	)
	main_menu_button.pressed.connect(func() -> void:
		emit_signal("main_menu_requested")
	)
	_ui_style.apply_panel(background as NinePatchRect, "ui.panel.pause", 0.95)
	_ui_style.apply_label(title_label, 19, _ui_style.FONT_PRIMARY, true)
	_ui_style.apply_button(continue_button, _ui_style.ACCENT_FOG, 11)
	_ui_style.apply_button(inventory_button, _ui_style.ACCENT_ASH, 11)
	_ui_style.apply_button(journal_button, _ui_style.ACCENT_ASH, 11)
	_ui_style.apply_button(settings_button, _ui_style.ACCENT_ASH, 11)
	_ui_style.apply_button(restart_button, _ui_style.ACCENT_FIRE, 11)
	_ui_style.apply_button(main_menu_button, _ui_style.ACCENT_ASH, 11)


func open() -> void:
	visible = true
	title_label.text = "Пауза"


func close() -> void:
	visible = false


func _emit_resume() -> void:
	emit_signal("resume_requested")


func _show_settings_placeholder() -> void:
	title_label.text = "Настройки будут добавлены позже"
