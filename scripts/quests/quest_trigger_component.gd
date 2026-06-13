extends InteractionComponent
class_name QuestTriggerComponent

@export var quest_id: String = ""
@export var stage_index: int = 1


func interact(actor: Node) -> void:
	if not can_interact(actor):
		return
	if quest_id != "":
		QuestManager.active_quest_id = quest_id
		QuestManager.set_stage(stage_index)
	super.interact(actor)


