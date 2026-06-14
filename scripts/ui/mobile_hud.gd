extends Control
class_name MobileHud

@onready var joystick: VirtualJoystick = $Joystick
@onready var attack_light_button: Button = $Buttons/AttackLightButton
@onready var attack_heavy_button: Button = $Buttons/AttackHeavyButton
@onready var dodge_button: Button = $Buttons/DodgeButton
@onready var interact_button: Button = $Buttons/InteractButton
@onready var heal_button: Button = $Buttons/HealButton
@onready var inventory_button: Button = $Buttons/InventoryButton
@onready var pause_button: Button = $PauseButton
@onready var health_bar: TextureProgressBar = $Bars/HealthBar
@onready var stamina_bar: TextureProgressBar = $Bars/StaminaBar
@onready var prompt_label: Label = $Buttons/InteractButton/PromptLabel

var _player: Node = null


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	attack_light_button.text = "Атк"
	attack_heavy_button.text = "Сил"
	dodge_button.text = "Рыв"
	interact_button.text = "Взаим"
	heal_button.text = "Леч"
	inventory_button.text = "Инв"
	pause_button.text = "Пауза"
	prompt_label.text = "Взаим"
	interact_button.visible = false
	for button in [attack_light_button, attack_heavy_button, dodge_button, interact_button, heal_button, inventory_button, pause_button]:
		button.focus_mode = Control.FOCUS_NONE
		button.clip_text = true
		button.add_theme_font_size_override("font_size", 12)
		_apply_button_skin(button)
	_wire_button(attack_light_button, "attack_light")
	_wire_button(attack_heavy_button, "attack_heavy")
	_wire_button(dodge_button, "dodge")
	_wire_button(interact_button, "interact")
	_wire_button(heal_button, "use_heal")
	_wire_button(inventory_button, "open_inventory")
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


func set_interaction_prompt(visible: bool, prompt_text: String) -> void:
	interact_button.visible = visible
	prompt_label.text = prompt_text if prompt_text != "" else "Взаим"


func _set_default_textures() -> void:
	health_bar.texture_under = AssetCatalog.texture("ui.bar.health_frame")
	health_bar.texture_progress = AssetCatalog.texture("ui.bar.health_fill")
	stamina_bar.texture_under = AssetCatalog.texture("ui.bar.stamina_frame")
	stamina_bar.texture_progress = AssetCatalog.texture("ui.bar.stamina_fill")
	_set_button_texture(attack_light_button, "ui.button.attack")
	_set_button_texture(attack_heavy_button, "ui.button.heavy_attack")
	_set_button_texture(dodge_button, "ui.button.dodge")
	_set_button_texture(interact_button, "ui.button.interact")
	_set_button_texture(heal_button, "ui.button.heal")
	_set_button_texture(inventory_button, "ui.button.inventory")
	_set_button_texture(pause_button, "ui.button.pause")


func _apply_button_skin(button: Button) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.08, 0.09, 0.11, 0.78)
	normal.border_color = Color(0.29, 0.21, 0.15, 0.9)
	normal.border_width_left = 2
	normal.border_width_top = 2
	normal.border_width_right = 2
	normal.border_width_bottom = 2
	normal.corner_radius_top_left = 7
	normal.corner_radius_top_right = 7
	normal.corner_radius_bottom_left = 7
	normal.corner_radius_bottom_right = 7
	normal.content_margin_left = 4
	normal.content_margin_right = 4
	normal.content_margin_top = 1
	normal.content_margin_bottom = 1
	button.add_theme_stylebox_override("normal", normal)

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color(0.12, 0.13, 0.16, 0.84)
	hover.border_color = Color(0.53, 0.37, 0.22, 0.96)
	button.add_theme_stylebox_override("hover", hover)

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color(0.18, 0.11, 0.09, 0.94)
	pressed.border_color = Color(0.81, 0.48, 0.23, 1.0)
	button.add_theme_stylebox_override("pressed", pressed)

	button.add_theme_color_override("font_color", Color(0.94, 0.95, 0.96, 1.0))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.95, 0.82, 1.0))
	button.add_theme_color_override("font_pressed_color", Color(1.0, 0.90, 0.70, 1.0))
	button.add_theme_color_override("font_disabled_color", Color(0.60, 0.62, 0.65, 1.0))


func _set_button_texture(button: Button, asset_id: String) -> void:
	var texture := AssetCatalog.texture(asset_id)
	if texture == null:
		return
	button.icon = texture
	button.expand_icon = true


func _wire_button(button: Button, action_name: String) -> void:
	button.pressed.connect(func() -> void:
		Input.action_press(action_name)
	)
	button.button_up.connect(func() -> void:
		Input.action_release(action_name)
	)
	button.button_down.connect(func() -> void:
		button.self_modulate = Color(1.08, 1.06, 1.0, 1.0)
	)
	button.button_up.connect(func() -> void:
		button.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
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
