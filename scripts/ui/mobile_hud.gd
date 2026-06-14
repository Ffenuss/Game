extends Control
class_name MobileHud

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
	attack_light_button.text = "Атака"
	attack_heavy_button.text = "Сил."
	dodge_button.text = "Рывок"
	interact_button.text = "Взаим."
	heal_button.text = "Леч."
	pause_button.text = "Пауза"
	prompt_label.text = "Взаим."
	interact_button.visible = false
	for button in [attack_light_button, attack_heavy_button, dodge_button, interact_button, heal_button, pause_button]:
		button.focus_mode = Control.FOCUS_NONE
		button.clip_text = true
		button.add_theme_font_size_override("font_size", 14)
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


func set_interaction_prompt(visible: bool, prompt_text: String) -> void:
	interact_button.visible = visible
	prompt_label.text = prompt_text if prompt_text != "" else "Взаимод."


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
