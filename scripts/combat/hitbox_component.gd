extends Area2D
class_name HitboxComponent

signal hit_confirmed(target: Node)

@export var damage: int = 1
@export var knockback: float = 120.0
@export var knockback_direction: Vector2 = Vector2.RIGHT
@export var active: bool = false
@export var owner_node_path: NodePath

var owner_node: Node = null
var _activation_serial: int = 0


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	if owner_node_path != NodePath():
		owner_node = get_node_or_null(owner_node_path)
	if owner_node == null:
		owner_node = get_parent()
	set_deferred("monitoring", active)


func set_active(value: bool) -> void:
	active = value
	set_deferred("monitoring", value)


func set_owner_direction(direction: Vector2) -> void:
	if direction.length_squared() <= 0.001:
		return
	knockback_direction = direction.normalized()


func activate_for(duration: float) -> void:
	_activation_serial += 1
	var serial := _activation_serial
	set_active(true)
	await get_tree().create_timer(duration).timeout
	if serial == _activation_serial:
		set_active(false)


func _on_area_entered(area: Area2D) -> void:
	if not active:
		return
	_try_hit(area)


func _on_body_entered(body: Node) -> void:
	if not active:
		return
	_try_hit(body)


func _try_hit(target: Node) -> void:
	if target == null or target == owner_node:
		return
	var knockback_vector := knockback_direction.normalized() * knockback
	if target.has_method("receive_hit"):
		target.call_deferred("receive_hit", damage, owner_node, knockback_vector)
		emit_signal("hit_confirmed", target)
		return
	var parent := target.get_parent()
	if parent != null and parent.has_method("receive_hit"):
		parent.call_deferred("receive_hit", damage, owner_node, knockback_vector)
		emit_signal("hit_confirmed", parent)

