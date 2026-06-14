extends Control
class_name MobileHud

const BUTTON_TEXTURES := {
	"attack_light": "ui.button.attack",
	"attack_heavy": "ui.button.heavy_attack",
	"dodge": "ui.button.dodge",
	"interact": "ui.button.interact",
	"use_heal": "ui.button.heal",
	"pause": "ui.button.pause",
}

@onready var joystick: VirtualJoystick = $Joystick
@onready var attack_light_button: Button = $Buttons/AttackLightButton
@onready var attack_heavy_button: Button = $Buttons/AttackHeavyButton
@onready var dodge_button: Button = $Buttons/DodgeButton
@onready var interact_button: Button = $Buttons/InteractButton
@onready var heal_button: Button = $Buttons/HealButton
@onready var pause_button: Button = $Buttons/PauseButton
@onready var health_bar: TextureProgressBar = $Bars/HealthBar
@onready var stamina_bar: TextureProgressBar = $Bars/StaminaBar
@onready var prompt_label: Label = $Buttons/InteractButton/PromptLabel

var _player: Node = null


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_style_button(attack_light_button, "Атака", BUTTON_TEXTURES["attack_light"], Color(0.78, 0.44, 0.22))
	_style_button(attack_heavy_button, "Сил.", BUTTON_TEXTURES["attack_heavy"], Color(0.58, 0.30, 0.18))
	_style_button(dodge_button, "Кувырок", BUTTON_TEXTURES["dodge"], Color(0.34, 0.52, 0.66))
	_style_button(interact_button, "Осмотр", BUTTON_TEXTURES["interact"], Color(0.56, 0.54, 0.26))
	_style_button(heal_button, "Трава", BUTTON_TEXTURES["use_heal"], Color(0.26, 0.58, 0.34))
	_style_button(pause_button, "Пауза", BUTTON_TEXTURES["pause"], Color(0.42, 0.44, 0.50))
	pause_button.text = "Пауза"
	interact_button.visible = false
	_wire_button(attack_light_button, "attack_light")
	_wire_button(attack_heavy_button, "attack_heavy")
	_wire_button(dodge_button, "dodge")
	_wire_button(interact_button, "interact")
	_wire_button(heal_button, "use_heal")
	_wire_button(pause_button, "pause")
	joystick.direction_changed.connect(_on_joystick_direction_changed)
	GameState.interaction_prompt_changed.connect(_on_interaction_prompt_changed)
	_set_default_textures()
	_on_interaction_prompt_changed(false, "")


func bind_player(player: Node) -> void:
	_player = player
	if _player == null:
		return
	var health: HealthComponent = _player.get_node_or_null("HealthComponent") as HealthComponent
	if health != null:
		health.health_changed.connect(_on_health_changed)
		_on_health_changed(health.current_health, health.max_health)
	var stamina: StaminaComponent = _player.get_node_or_null("StaminaComponent") as StaminaComponent
	if stamina != null:
		stamina.stamina_changed.connect(_on_stamina_changed)
		_on_stamina_changed(stamina.current_stamina, stamina.max_stamina)


func clear_player() -> void:
	_player = null


func set_interaction_prompt(is_visible: bool, prompt_text: String) -> void:
	interact_button.visible = is_visible
	prompt_label.text = prompt_text if prompt_text != "" else "Взаимод."


func _style_button(button: Button, text: String, texture_id: String, accent: Color) -> void:
	button.text = text
	button.icon = AssetCatalog.texture(texture_id)
	button.expand_icon = true
	button.flat = true
	button.clip_text = true
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_color_override("font_color", Color(0.96, 0.96, 0.94))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.98, 0.84))
	button.add_theme_color_override("font_pressed_color", Color(1.0, 0.92, 0.70))
	button.add_theme_color_override("font_focus_color", Color(1.0, 0.95, 0.78))
	button.add_theme_color_override("icon_normal_color", Color(1.0, 1.0, 1.0))
	button.add_theme_stylebox_override("normal", _build_button_style(Color(0.11, 0.11, 0.12, 0.74), accent, 2.0))
	button.add_theme_stylebox_override("hover", _build_button_style(Color(0.16, 0.15, 0.16, 0.82), accent.lightened(0.1), 2.0))
	button.add_theme_stylebox_override("pressed", _build_button_style(Color(0.09, 0.09, 0.10, 0.92), accent.darkened(0.12), 2.0))
	button.add_theme_stylebox_override("disabled", _build_button_style(Color(0.08, 0.08, 0.08, 0.54), Color(0.35, 0.35, 0.35), 2.0))
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.size_flags_vertical = Control.SIZE_EXPAND_FILL


func _build_button_style(fill: Color, border: Color, border_width: float) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.border_width_left = int(border_width)
	style.border_width_top = int(border_width)
	style.border_width_right = int(border_width)
	style.border_width_bottom = int(border_width)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 10.0
	style.content_margin_top = 6.0
	style.content_margin_right = 10.0
	style.content_margin_bottom = 6.0
	return style


func _set_default_textures() -> void:
	health_bar.texture_under = AssetCatalog.texture("ui.bar.health_frame")
	health_bar.texture_progress = AssetCatalog.texture("ui.bar.health_fill")
	stamina_bar.texture_under = AssetCatalog.texture("ui.bar.stamina_frame")
	stamina_bar.texture_progress = AssetCatalog.texture("ui.bar.stamina_fill")


func _wire_button(button: Button, action_name: String) -> void:
	button.pressed.connect(func() -> void:
		Input.action_press(action_name)
	)
	button.button_up.connect(func() -> void:
		Input.action_release(action_name)
	)


func _on_joystick_direction_changed(direction: Vector2) -> void:
	GameState.set_movement_override(direction)


func _on_interaction_prompt_changed(visible: bool, prompt_text: String) -> void:
	set_interaction_prompt(visible, prompt_text)


func _on_health_changed(current_health: int, max_health: int) -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health


func _on_stamina_changed(current_stamina: float, max_stamina: float) -> void:
	stamina_bar.max_value = max_stamina
	stamina_bar.value = current_stamina
