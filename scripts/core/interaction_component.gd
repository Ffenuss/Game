extends Area2D
class_name InteractionComponent

signal interacted(actor: Node)

@export var prompt_text: String = "Взаимодействовать"
@export var enabled: bool = true


func can_interact(_actor: Node) -> bool:
	return enabled


func interact(actor: Node) -> void:
	if not can_interact(actor):
		return
	emit_signal("interacted", actor)


