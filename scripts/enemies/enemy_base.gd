extends CharacterBody2D
class_name EnemyBase

enum EnemyState { IDLE, CHASE, TELEGRAPH, ATTACK, HIT, DEAD }

@export var enemy_id: String = "enemy.placeholder"
@export var can_move: bool = true
@export var can_attack: bool = true
@export var wander_speed: float = 18.0
@export var move_speed: float = 58.0
@export var detection_range: float = 150.0
@export var attack_range: float = 24.0
@export var attack_damage: int = 1
@export var telegraph_time: float = 0.3
@export var attack_active_time: float = 0.16
@export var attack_recovery_time: float = 0.5

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var attack_origin: Node2D = $AttackOrigin
@onready var attack_hitbox: HitboxComponent = $AttackOrigin/HitboxComponent
@onready var state_machine: Node = $StateMachine

var state: EnemyState = EnemyState.IDLE
var _state_timer: float = 0.0
var _attack_cooldown: float = 0.0
var _player: Node = null
var _facing_flip: bool = false

const ENEMY_ANIMATIONS := ["idle", "walk", "attack", "hit", "death"]
const ENEMY_ANIMATION_REGIONS := {
	"idle": Rect2i(0, 0, 32, 32),
	"walk": Rect2i(0, 1, 32, 32),
	"attack": Rect2i(0, 2, 32, 32),
	"hit": Rect2i(0, 3, 32, 32),
	"death": Rect2i(0, 4, 32, 32),
}


func _ready() -> void:
	add_to_group("enemy")
	sprite.sprite_frames = _build_sprite_frames()
	sprite.play("idle")
	health_component.health_changed.connect(_on_health_changed)
	health_component.died.connect(_on_health_died)
	hurtbox.hit_received.connect(_on_hurtbox_hit_received)
	hurtbox.death_requested.connect(_on_hurtbox_death_requested)
	attack_hitbox.owner_node = self
	_load_enemy_data()
	_player = GameState.current_player
	if _player == null:
		_player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if state == EnemyState.DEAD:
		velocity = Vector2.ZERO
		return

	_state_timer = max(0.0, _state_timer - delta)
	_attack_cooldown = max(0.0, _attack_cooldown - delta)
	_refresh_player_reference()

	if _player == null:
		velocity = velocity.move_toward(Vector2.ZERO, 300.0 * delta)
		move_and_slide()
		_update_visual_state()
		return

		var to_player: Vector2 = _player.global_position - global_position
		var distance: float = to_player.length()
	if distance > detection_range:
		if can_move:
			velocity = velocity.move_toward(Vector2.ZERO, 260.0 * delta)
		else:
			velocity = Vector2.ZERO
		state = EnemyState.IDLE
		elif can_attack and distance <= attack_range and _attack_cooldown <= 0.0:
			_begin_attack()
		elif can_move:
			state = EnemyState.CHASE
			var direction: Vector2 = to_player.normalized()
			velocity = velocity.move_toward(direction * move_speed, 520.0 * delta)
			_facing_flip = direction.x < 0.0
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 260.0 * delta)

	move_and_slide()
	_update_attack_origin()
	_update_visual_state()
	if state != EnemyState.DEAD and _state_timer <= 0.0 and state == EnemyState.HIT:
		state = EnemyState.IDLE


func receive_hit(damage: int, source: Node = null, knockback: Vector2 = Vector2.ZERO) -> bool:
	return hurtbox.receive_hit(damage, source, knockback)


func _load_enemy_data() -> void:
	var path := "res://data/enemies/%s.json" % enemy_id
	if not FileAccess.file_exists(path):
		return
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		return
	var data: Dictionary = parsed as Dictionary
	if data.has("max_health"):
		health_component.max_health = int(data["max_health"])
		health_component.current_health = int(data["max_health"])
	attack_damage = int(data.get("attack_damage", attack_damage))
	move_speed = float(data.get("move_speed", move_speed))
	wander_speed = float(data.get("wander_speed", wander_speed))
	detection_range = float(data.get("detection_range", detection_range))
	attack_range = float(data.get("attack_range", attack_range))
	can_move = bool(data.get("can_move", can_move))
	can_attack = bool(data.get("can_attack", can_attack))
	if data.has("asset_prefix"):
		enemy_id = String(data["asset_prefix"])
	sprite.sprite_frames = _build_sprite_frames()


func _begin_attack() -> void:
	if state == EnemyState.DEAD or state == EnemyState.ATTACK:
		return
	state = EnemyState.TELEGRAPH
	_state_timer = telegraph_time + attack_active_time + attack_recovery_time
	_attack_cooldown = telegraph_time + attack_active_time + attack_recovery_time
	attack_hitbox.damage = attack_damage
	attack_hitbox.knockback = 110.0
	attack_hitbox.set_owner_direction(Vector2.LEFT if _facing_flip else Vector2.RIGHT)
	_run_attack_window()


func _run_attack_window() -> void:
	await get_tree().create_timer(telegraph_time).timeout
	if state == EnemyState.DEAD or state == EnemyState.HIT:
		return
	state = EnemyState.ATTACK
	attack_hitbox.set_active(true)
	await get_tree().create_timer(attack_active_time).timeout
	attack_hitbox.set_active(false)
	if state != EnemyState.DEAD and state != EnemyState.HIT:
		state = EnemyState.IDLE


func _refresh_player_reference() -> void:
	if _player != null and is_instance_valid(_player):
		return
	_player = GameState.current_player
	if _player == null:
		_player = get_tree().get_first_node_in_group("player")


func _build_sprite_frames() -> SpriteFrames:
	var frames := SpriteFrames.new()
	for animation_name in ENEMY_ANIMATIONS:
		frames.add_animation(animation_name)
		frames.set_animation_speed(animation_name, 4.0)
		frames.set_animation_loop(animation_name, animation_name != "death")
		var texture := _load_base_texture("enemy.%s.%s" % [enemy_id, animation_name])
		if texture != null:
			var region: Rect2i = ENEMY_ANIMATION_REGIONS.get(animation_name, Rect2i())
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


func _update_visual_state() -> void:
	var animation_name := "idle"
	match state:
		EnemyState.IDLE:
			animation_name = "idle"
		EnemyState.CHASE:
			animation_name = "walk"
		EnemyState.TELEGRAPH:
			animation_name = "attack"
		EnemyState.ATTACK:
			animation_name = "attack"
		EnemyState.HIT:
			animation_name = "hit"
		EnemyState.DEAD:
			animation_name = "death"
	if sprite.sprite_frames != null and sprite.sprite_frames.has_animation(animation_name):
		if sprite.animation != animation_name:
			sprite.play(animation_name)
	sprite.flip_h = _facing_flip


func _update_attack_origin() -> void:
	var offset := Vector2.LEFT if _facing_flip else Vector2.RIGHT
	attack_origin.position = offset * 10.0
	if attack_hitbox != null and attack_hitbox.has_method("set_owner_direction"):
		attack_hitbox.call("set_owner_direction", offset)


func _on_health_changed(_current_health: int, _max_health: int) -> void:
	pass


func _on_health_died() -> void:
	_die()


func _on_hurtbox_hit_received(_damage: int, _source: Node, knockback: Vector2) -> void:
	if state == EnemyState.DEAD:
		return
	state = EnemyState.HIT
	_state_timer = 0.22
	velocity = knockback
	if velocity.length_squared() < 0.001:
		velocity = Vector2(-80.0 if _facing_flip else 80.0, 0.0)


func _on_hurtbox_death_requested() -> void:
	_die()


func _die() -> void:
	if state == EnemyState.DEAD:
		return
	state = EnemyState.DEAD
	attack_hitbox.set_active(false)
	velocity = Vector2.ZERO
	sprite.play("death")
	call_deferred("queue_free")
