extends SceneTree

const START_SCENE_PATH := "res://scenes/boot/boot.tscn"
const FRAME_WAIT_COUNT := 3


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if not ResourceLoader.exists(START_SCENE_PATH):
		push_error("validate_runtime_smoke: missing start scene %s" % START_SCENE_PATH)
		quit(1)
		return

	var change_error := change_scene_to_file(START_SCENE_PATH)
	if change_error != OK:
		push_error("validate_runtime_smoke: unable to start project scene %s" % START_SCENE_PATH)
		quit(1)
		return

	for _index in range(FRAME_WAIT_COUNT):
		await process_frame

	if current_scene == null:
		push_error("validate_runtime_smoke: no current scene after startup.")
		quit(1)
		return

	print("validate_runtime_smoke: started %s" % current_scene.scene_file_path)
	quit(0)
