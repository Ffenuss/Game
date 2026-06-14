extends Area2D
class_name HurtboxComponent

signal hit_received(damage: int, source: Node, knockback: Vector2)
signal death_requested()

@export var health_component_path: NodePath
@export var invulnerable: bool = false

var health_component: HealthComponent = null


func _ready() -> void:
	if health_component_path != NodePath():
		health_component = get_node_or_null(health_component_path) as HealthComponent
	if health_component == null:
		health_component = get_parent().get_node_or_null("HealthComponent") as HealthComponent


func receive_hit(damage: int, source: Node = null, knockback: Vector2 = Vector2.ZERO) -> bool:
	if invulnerable:
		return false
	emit_signal("hit_received", damage, source, knockback)
	if health_component != null:
		health_component.damage(damage)
		if health_component.is_dead():
			emit_signal("death_requested")
	return true


func set_temporary_invulnerability(duration: float) -> void:
	if duration <= 0.0:
		return
	invulnerable = true
	await get_tree().create_timer(duration).timeout
	invulnerable = false


