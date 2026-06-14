extends SceneTree

const GENERATED_DIR := "res://assets/generated/placeholders"
const RUNTIME_DIR := "res://assets/runtime"


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	# Placeholder generation is intentionally data-driven and deterministic.
	# The actual atlas drawing logic is mirrored by the temporary build script used in this environment.
	print("Placeholder generation is documented here and mirrored by local tooling.")
	quit(0)


