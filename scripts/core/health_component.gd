extends Node
class_name HealthComponent

signal health_changed(current_health: int, max_health: int)
signal died()

@export var max_health: int = 10
@export var current_health: int = 10


func _ready() -> void:
	max_health = max(1, max_health)
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", current_health, max_health)


func set_max_health(value: int, refill: bool = true) -> void:
	max_health = max(1, value)
	if refill:
		current_health = max_health
	else:
		current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", current_health, max_health)


func set_health(value: int) -> void:
	current_health = clamp(value, 0, max_health)
	emit_signal("health_changed", current_health, max_health)
	if current_health <= 0:
		emit_signal("died")


func damage(amount: int) -> int:
	if amount <= 0 or current_health <= 0:
		return 0
	var applied: int = min(amount, current_health)
	current_health -= applied
	emit_signal("health_changed", current_health, max_health)
	if current_health <= 0:
		emit_signal("died")
	return applied


func heal(amount: int) -> int:
	if amount <= 0 or current_health <= 0:
		return 0
	var before := current_health
	current_health = clamp(current_health + amount, 0, max_health)
	emit_signal("health_changed", current_health, max_health)
	return current_health - before


func restore_full() -> void:
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)


func is_dead() -> bool:
	return current_health <= 0


func export_snapshot() -> Dictionary:
	return {
		"max_health": max_health,
		"current_health": current_health,
	}


func apply_snapshot(snapshot: Dictionary) -> void:
	if snapshot.is_empty():
		return
	max_health = int(snapshot.get("max_health", max_health))
	current_health = int(snapshot.get("current_health", current_health))
	max_health = max(1, max_health)
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", current_health, max_health)

