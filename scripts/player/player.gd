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
	camera.make_current()
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
