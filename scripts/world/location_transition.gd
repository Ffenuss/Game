extends InteractionComponent
class_name LocationTransition

@export var target_location_id: String = ""
@export var target_spawn_label: String = ""


func interact(actor: Node) -> void:
	if not can_interact(actor):
		return
	if target_location_id != "":
		SceneRouter.load_location(target_location_id)
	super.interact(actor)


