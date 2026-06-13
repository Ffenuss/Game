extends Node
class_name StaminaComponent

signal stamina_changed(current_stamina: float, max_stamina: float)

@export var max_stamina: float = 100.0
@export var current_stamina: float = 100.0
@export var regen_per_second: float = 22.0
@export var regen_delay: float = 0.25

var _regen_lock_timer: float = 0.0


func _ready() -> void:
	max_stamina = max(1.0, max_stamina)
	current_stamina = clamp(current_stamina, 0.0, max_stamina)
	emit_signal("stamina_changed", current_stamina, max_stamina)


func _physics_process(delta: float) -> void:
	if _regen_lock_timer > 0.0:
		_regen_lock_timer -= delta
		return
	if current_stamina < max_stamina:
		current_stamina = min(max_stamina, current_stamina + regen_per_second * delta)
		emit_signal("stamina_changed", current_stamina, max_stamina)


func consume(amount: float) -> bool:
	if amount <= 0.0 or current_stamina < amount:
		return false
	current_stamina = max(0.0, current_stamina - amount)
	_regen_lock_timer = regen_delay
	emit_signal("stamina_changed", current_stamina, max_stamina)
	return true


func restore(amount: float) -> float:
	if amount <= 0.0:
		return 0.0
	var before := current_stamina
	current_stamina = clamp(current_stamina + amount, 0.0, max_stamina)
	emit_signal("stamina_changed", current_stamina, max_stamina)
	return current_stamina - before


func restore_full() -> void:
	current_stamina = max_stamina
	emit_signal("stamina_changed", current_stamina, max_stamina)


func export_snapshot() -> Dictionary:
	return {
		"max_stamina": max_stamina,
		"current_stamina": current_stamina,
	}


func apply_snapshot(snapshot: Dictionary) -> void:
	if snapshot.is_empty():
		return
	max_stamina = float(snapshot.get("max_stamina", max_stamina))
	current_stamina = float(snapshot.get("current_stamina", current_stamina))
	max_stamina = max(1.0, max_stamina)
	current_stamina = clamp(current_stamina, 0.0, max_stamina)
	emit_signal("stamina_changed", current_stamina, max_stamina)


