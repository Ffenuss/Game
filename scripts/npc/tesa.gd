extends CharacterBody2D
class_name TessaNPC

@export var dialogue_id: String = "tesa_intro"
@export var speaker_name: String = "Тесса"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var dialogue_trigger: DialogueTriggerComponent = $DialogueTriggerComponent


func _ready() -> void:
	dialogue_trigger.dialogue_id = dialogue_id
	dialogue_trigger.speaker_name = speaker_name
	sprite.sprite_frames = _build_sprite_frames()
	sprite.play("idle")


func _build_sprite_frames() -> SpriteFrames:
	var frames := SpriteFrames.new()
	frames.add_animation("idle")
	frames.set_animation_loop("idle", true)
	frames.set_animation_speed("idle", 2.0)
	var texture := AssetCatalog.texture("npc.tessa.idle")
	if texture != null:
		frames.add_frame("idle", texture)
	return frames


