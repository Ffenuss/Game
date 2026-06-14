extends Control
class_name MobileHud

const UI_STYLE_SCRIPT := preload("res://scripts/ui/ui_style.gd")

@onready var status_frame: NinePatchRect = $StatusFrame
@onready var action_frame: NinePatchRect = $ActionFrame
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
var _ui_style := UI_STYLE_SCRIPT.new()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	attack_light_button.text = "Атк"
	attack_heavy_button.text = "Сил"
	dodge_button.text = "Рыв"
	interact_button.text = "Взаим"
	heal_button.text = "Леч"
	inventory_button.text = "Инв"
	pause_button.text = "Пау"
	prompt_label.text = "Взаим"
	interact_button.visible = false
	_ui_style.apply_panel(status_frame, "ui.panel.dialogue", 0.80)
	_ui_style.apply_panel(action_frame, "ui.panel.inventory", 0.82)
	_ui_style.apply_button(attack_light_button, _ui_style.ACCENT_FIRE, 9)
	_ui_style.apply_button(attack_heavy_button, _ui_style.ACCENT_HEAVY, 9)
	_ui_style.apply_button(dodge_button, _ui_style.ACCENT_FOG, 9)
	_ui_style.apply_button(interact_button, _ui_style.ACCENT_HEAL, 9)
	_ui_style.apply_button(heal_button, _ui_style.ACCENT_HEAL, 9)
	_ui_style.apply_button(inventory_button, _ui_style.ACCENT_ASH, 9)
	_ui_style.apply_button(pause_button, _ui_style.ACCENT_ASH, 9)
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
	_ui_style.apply_label(prompt_label, 9, _ui_style.FONT_SECONDARY, true)
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
