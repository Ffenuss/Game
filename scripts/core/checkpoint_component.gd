extends InteractionComponent
class_name CheckpointComponent

signal checkpoint_activated(checkpoint_id: String, position: Vector2)

@export var checkpoint_id: String = "checkpoint_warm_stone"
@export var respawn_offset: Vector2 = Vector2(0, 24)
@export var restore_health: bool = true
@export var restore_stamina: bool = true


func interact(actor: Node) -> void:
	if not can_interact(actor):
		return
	if restore_health and actor != null and actor.has_node("HealthComponent"):
		var health := actor.get_node("HealthComponent") as HealthComponent
		if health != null:
			health.restore_full()
	if restore_stamina and actor != null and actor.has_node("StaminaComponent"):
		var stamina := actor.get_node("StaminaComponent") as StaminaComponent
		if stamina != null:
			stamina.restore_full()
	GameState.set_checkpoint(checkpoint_id, global_position + respawn_offset)
	emit_signal("checkpoint_activated", checkpoint_id, global_position + respawn_offset)
	SaveManager.autosave("checkpoint")
	super.interact(actor)


