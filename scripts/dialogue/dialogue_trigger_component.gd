extends InteractionComponent
class_name DialogueTriggerComponent

@export var dialogue_id: String = ""
@export var speaker_name: String = ""
@export var auto_start: bool = true


func interact(actor: Node) -> void:
	if not can_interact(actor):
		return
	if dialogue_id != "":
		GameState.request_dialogue(dialogue_id, speaker_name)
	super.interact(actor)


