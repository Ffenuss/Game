extends CharacterBody2D
class_name PlayerCharacter

enum PlayerState { IDLE, WALK, ATTACK_LIGHT, ATTACK_HEAVY, DODGE, HIT, DEAD }

@export var move_speed: float = 125.0
@export var acceleration: float = 900.0
@export var deceleration: float = 1200.0
@export var dodge_speed: float = 230.0
@export var dodge_duration: float = 0.24
@export var dodge_stamina_cost: float = 18.0
@export var light_attack_stamina_cost: float = 14.0
@export var heavy_attack_stamina_cost: float = 28.0
@export var light_attack_damage: int = 2
@export var heavy_attack_damage: int = 4
@export var light_attack_windup: float = 0.08
@export var light_attack_window: float = 0.14
@export var light_attack_recovery: float = 0.18
@export var heavy_attack_windup: float = 0.14
@export var heavy_attack_window: float = 0.22
@export var heavy_attack_recovery: float = 0.26
@export var hit_recovery: float = 0.28
@export var heal_amount: int = 4

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var camera: Camera2D = $Camera2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var stamina_component: StaminaComponent = $StaminaComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var attack_origin: Node2D = $AttackOrigin
@onready var attack_hitbox: HitboxComponent = $AttackOrigin/HitboxComponent
@onready var interaction_area: Area2D = $InteractionArea
@onready var state_machine: Node = $StateMachine

var state: PlayerState = PlayerState.IDLE
var facing: String = "down"
var _state_timer: float = 0.0
var _attack_active: bool = false
var _current_interactable: Node = null
var _last_motion: Vector2 = Vector2.DOWN
var _spawn_position: Vector2 = Vector2.ZERO

const DIRECTION_VECTORS := {
	"down": Vector2.DOWN,
	"up": Vector2.UP,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
}

const ANIMATION_IDS := {
	"idle_down": "player.placeholder.idle_down",
	"idle_up": "player.placeholder.idle_up",
	"idle_left": "player.placeholder.idle_left",
	"idle_right": "player.placeholder.idle_right",
	"walk_down": "player.placeholder.walk_down",
	"walk_up": "player.placeholder.walk_up",
	"walk_left": "player.placeholder.walk_left",
	"walk_right": "player.placeholder.walk_right",
	"attack_light_down": "player.placeholder.attack_light_down",
	"attack_light_up": "player.placeholder.attack_light_up",
	"attack_light_left": "player.placeholder.attack_light_left",
	"attack_light_right": "player.placeholder.attack_light_right",
	"attack_heavy_down": "player.placeholder.attack_heavy_down",
	"attack_heavy_up": "player.placeholder.attack_heavy_up",
	"attack_heavy_left": "player.placeholder.attack_heavy_left",
	"attack_heavy_right": "player.placeholder.attack_heavy_right",
	"dodge_down": "player.placeholder.dodge_down",
	"dodge_up": "player.placeholder.dodge_up",
	"dodge_left": "player.placeholder.dodge_left",
	"dodge_right": "player.placeholder.dodge_right",
	"hit": "player.placeholder.hit",
	"death": "player.placeholder.death",
}

const ANIMATION_REGIONS := {
	"idle_down": Rect2i(0, 0, 32, 48),
	"idle_left": Rect2i(1, 0, 32, 48),
	"idle_right": Rect2i(2, 0, 32, 48),
	"idle_up": Rect2i(3, 0, 32, 48),
	"walk_down": Rect2i(0, 1, 32, 48),
	"walk_left": Rect2i(1, 1, 32, 48),
	"walk_right": Rect2i(2, 1, 32, 48),
	"walk_up": Rect2i(3, 1, 32, 48),
	"attack_light_down": Rect2i(0, 2, 32, 48),
	"attack_light_left": Rect2i(1, 2, 32, 48),
	"attack_light_right": Rect2i(2, 2, 32, 48),
	"attack_light_up": Rect2i(3, 2, 32, 48),
	"attack_heavy_down": Rect2i(0, 3, 32, 48),
	"attack_heavy_left": Rect2i(1, 3, 32, 48),
	"attack_heavy_right": Rect2i(2, 3, 32, 48),
	"attack_heavy_up": Rect2i(3, 3, 32, 48),
	"dodge_down": Rect2i(0, 4, 32, 48),
	"dodge_left": Rect2i(1, 4, 32, 48),
	"dodge_right": Rect2i(2, 4, 32, 48),
	"dodge_up": Rect2i(3, 4, 32, 48),
	"hit": Rect2i(0, 5, 32, 48),
	"death": Rect2i(1, 5, 32, 48),
}


func _ready() -> void:
	add_to_group("player")
	camera.current = true
	sprite.sprite_frames = _build_sprite_frames()
	sprite.play("idle_down")
	health_component.health_changed.connect(_on_health_changed)
	health_component.died.connect(_on_health_died)
	stamina_component.stamina_changed.connect(_on_stamina_changed)
	hurtbox.hit_received.connect(_on_hurtbox_hit_received)
	hurtbox.death_requested.connect(_on_hurtbox_death_requested)
	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)
	attack_hitbox.owner_node = self
	GameState.register_player(self)
	_apply_save_snapshot()


func initialize(spawn_position: Vector2, snapshot: Dictionary = {}) -> void:
	_spawn_position = spawn_position
	global_position = spawn_position
	if snapshot.is_empty():
		_apply_save_snapshot()
	else:
		apply_snapshot(snapshot)


func _physics_process(delta: float) -> void:
	if state == PlayerState.DEAD:
		velocity = Vector2.ZERO
		return

	_state_timer = max(0.0, _state_timer - delta)
	var movement_input := GameState.get_movement_vector()
	if movement_input.length_squared() > 1.0:
		movement_input = movement_input.normalized()

	_update_facing(movement_input)

	if _consume_action("pause"):
		GameState.request_pause()
		return
	if _consume_action("attack_heavy"):
		_start_attack(true)
	elif _consume_action("attack_light"):
		_start_attack(false)
	if _consume_action("dodge"):
		_start_dodge(movement_input)
	if _consume_action("interact"):
		_interact_with_current()
	if _consume_action("use_heal"):
		_use_heal_item()

	if state == PlayerState.DODGE:
		velocity = DIRECTION_VECTORS[facing] * dodge_speed
	elif state == PlayerState.ATTACK_LIGHT or state == PlayerState.ATTACK_HEAVY or state == PlayerState.HIT:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	else:
		var target_velocity := movement_input * move_speed
		if movement_input.length_squared() > 0.001:
			velocity = velocity.move_toward(target_velocity, acceleration * delta)
			if state != PlayerState.WALK:
				state = PlayerState.WALK
		else:
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
			if state == PlayerState.WALK or state == PlayerState.IDLE:
				state = PlayerState.IDLE
			if state != PlayerState.WALK:
				state = PlayerState.IDLE

	move_and_slide()
	_update_attack_origin()
	_update_visual_state()

	if state != PlayerState.DEAD:
		GameState.remember_player_snapshot(export_snapshot())

	if _state_timer <= 0.0:
		if state == PlayerState.DODGE:
			state = PlayerState.IDLE
			hurtbox.invulnerable = false
		elif state == PlayerState.ATTACK_LIGHT or state == PlayerState.ATTACK_HEAVY:
			state = PlayerState.IDLE
		elif state == PlayerState.HIT:
			state = PlayerState.IDLE


func apply_snapshot(snapshot: Dictionary) -> void:
	health_component.apply_snapshot(snapshot.get("health", {}))
	stamina_component.apply_snapshot(snapshot.get("stamina", {}))
	facing = String(snapshot.get("facing", facing))
	if snapshot.has("position"):
		var position_data: Array = snapshot.get("position", [])
		if position_data.size() >= 2:
			global_position = Vector2(float(position_data[0]), float(position_data[1]))
	state = PlayerState.IDLE
	_update_visual_state()


func export_snapshot() -> Dictionary:
	return {
		"position": [global_position.x, global_position.y],
		"facing": facing,
		"health": health_component.export_snapshot(),
		"stamina": stamina_component.export_snapshot(),
		"state": state,
	}


func receive_hit(damage: int, source: Node = null, knockback: Vector2 = Vector2.ZERO) -> bool:
	return hurtbox.receive_hit(damage, source, knockback)


func _consume_action(action_name: String) -> bool:
	if Input.is_action_just_pressed(action_name):
		return true
	return false


func _update_facing(movement_input: Vector2) -> void:
	if movement_input.length_squared() <= 0.001:
		return
	if abs(movement_input.x) > abs(movement_input.y):
		facing = "right" if movement_input.x > 0.0 else "left"
	else:
		facing = "down" if movement_input.y > 0.0 else "up"
	_last_motion = movement_input


func _start_attack(is_heavy: bool) -> void:
	if state == PlayerState.DEAD or state == PlayerState.DODGE or state == PlayerState.HIT:
		return
	if state == PlayerState.ATTACK_LIGHT or state == PlayerState.ATTACK_HEAVY:
		return
	var cost := heavy_attack_stamina_cost if is_heavy else light_attack_stamina_cost
	if not stamina_component.consume(cost):
		return
	state = PlayerState.ATTACK_HEAVY if is_heavy else PlayerState.ATTACK_LIGHT
	var windup := heavy_attack_windup if is_heavy else light_attack_windup
	var active_window := heavy_attack_window if is_heavy else light_attack_window
	var recovery := heavy_attack_recovery if is_heavy else light_attack_recovery
	var damage := heavy_attack_damage if is_heavy else light_attack_damage
	_state_timer = windup + active_window + recovery
	attack_hitbox.damage = damage
	attack_hitbox.knockback = 180.0 if is_heavy else 130.0
	_start_attack_window(windup, active_window)


func _start_attack_window(windup: float, active_window: float) -> void:
	if _attack_active:
		return
	_attack_active = true
	await get_tree().create_timer(windup).timeout
	if state == PlayerState.DEAD:
		_attack_active = false
		return
	attack_hitbox.set_active(true)
	await get_tree().create_timer(active_window).timeout
	attack_hitbox.set_active(false)
	_attack_active = false


func _start_dodge(movement_input: Vector2) -> void:
	if state == PlayerState.DEAD or state == PlayerState.DODGE or state == PlayerState.ATTACK_LIGHT or state == PlayerState.ATTACK_HEAVY:
		return
	if not stamina_component.consume(dodge_stamina_cost):
		return
	state = PlayerState.DODGE
	_state_timer = dodge_duration
	hurtbox.invulnerable = true
	if movement_input.length_squared() > 0.001:
		_last_motion = movement_input.normalized()
		_update_facing(_last_motion)
	velocity = DIRECTION_VECTORS[facing] * dodge_speed


func _interact_with_current() -> void:
	if _current_interactable == null:
		return
	if _current_interactable.has_method("interact"):
		_current_interactable.interact(self)


func _use_heal_item() -> void:
	if GameState.consume_inventory_item("healing_herb", 1):
		heal(heal_amount)


func heal(amount: int) -> int:
	var healed: int = health_component.heal(amount)
	if healed > 0:
		stamina_component.restore(float(amount) * 2.0)
		GameState.remember_player_snapshot(export_snapshot())
	return healed


func _update_attack_origin() -> void:
	attack_origin.position = DIRECTION_VECTORS[facing] * 12.0
	if attack_hitbox != null and attack_hitbox.has_method("set_owner_direction"):
		attack_hitbox.call("set_owner_direction", DIRECTION_VECTORS[facing])


func _update_visual_state() -> void:
	var animation_name := "idle_%s" % facing
	match state:
		PlayerState.WALK:
			animation_name = "walk_%s" % facing
		PlayerState.ATTACK_LIGHT:
			animation_name = "attack_light_%s" % facing
		PlayerState.ATTACK_HEAVY:
			animation_name = "attack_heavy_%s" % facing
		PlayerState.DODGE:
			animation_name = "dodge_%s" % facing
		PlayerState.HIT:
			animation_name = "hit"
		PlayerState.DEAD:
			animation_name = "death"
		_:
			animation_name = "idle_%s" % facing
	if sprite.sprite_frames != null and sprite.sprite_frames.has_animation(animation_name):
		if sprite.animation != animation_name:
			sprite.play(animation_name)


func _build_sprite_frames() -> SpriteFrames:
	var frames := SpriteFrames.new()
	for animation_name in ANIMATION_IDS.keys():
		frames.add_animation(animation_name)
		frames.set_animation_speed(animation_name, 4.0)
		frames.set_animation_loop(animation_name, animation_name.begins_with("idle") or animation_name.begins_with("walk"))
		var texture := _load_base_texture(String(ANIMATION_IDS[animation_name]))
		if texture != null:
			var region: Rect2i = ANIMATION_REGIONS.get(animation_name, Rect2i())
			if region.size != Vector2i.ZERO:
				var atlas_texture := AtlasTexture.new()
				atlas_texture.atlas = texture
				atlas_texture.region = Rect2(float(region.position.x), float(region.position.y), float(region.size.x), float(region.size.y))
				frames.add_frame(animation_name, atlas_texture)
			else:
				frames.add_frame(animation_name, texture)
	return frames


func _load_base_texture(asset_id: String) -> Texture2D:
	var path := AssetCatalog.resolve_path(asset_id)
	if path == "":
		return null
	return load(path) as Texture2D


func _on_health_changed(_current_health: int, _max_health: int) -> void:
	GameState.remember_player_snapshot(export_snapshot())


func _on_stamina_changed(_current_stamina: float, _max_stamina: float) -> void:
	GameState.remember_player_snapshot(export_snapshot())


func _on_health_died() -> void:
	_die()


func _on_hurtbox_hit_received(_damage: int, _source: Node, knockback: Vector2) -> void:
	if state == PlayerState.DEAD:
		return
	if state == PlayerState.DODGE:
		return
	state = PlayerState.HIT
	_state_timer = hit_recovery
	hurtbox.invulnerable = true
	velocity = knockback
	if velocity.length_squared() < 0.001:
		velocity = -DIRECTION_VECTORS[facing] * 80.0


func _on_hurtbox_death_requested() -> void:
	_die()


func _die() -> void:
	if state == PlayerState.DEAD:
		return
	state = PlayerState.DEAD
	attack_hitbox.set_active(false)
	velocity = Vector2.ZERO
	_save_game_state_and_respawn()


func _apply_save_snapshot() -> void:
	if GameState.player_snapshot.is_empty():
		return
	apply_snapshot(GameState.player_snapshot)


func _on_interaction_area_entered(area: Area2D) -> void:
	if area != null and area.has_method("interact"):
		_current_interactable = area
		var prompt_text := "Взаимодействовать"
		if area.has_method("get"):
			var candidate := String(area.get("prompt_text"))
			if candidate != "":
				prompt_text = candidate
		GameState.set_interaction_prompt(true, prompt_text)


func _on_interaction_area_exited(area: Area2D) -> void:
	if _current_interactable == area:
		_current_interactable = null
		GameState.set_interaction_prompt(false, "")


func _save_game_state_and_respawn() -> void:
	GameState.remember_player_snapshot(export_snapshot())
	if not SaveManager.load_game():
		GameState.remember_player_snapshot(export_snapshot())
	await get_tree().create_timer(0.6).timeout
	SceneRouter.reload_current_location()
