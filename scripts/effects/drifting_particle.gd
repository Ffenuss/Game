extends Sprite2D
class_name DriftingParticle

@export var drift_velocity: Vector2 = Vector2(-8.0, -1.0)
@export var drift_amplitude: float = 4.0
@export var drift_frequency: float = 1.0
@export var wrap_size: Vector2 = Vector2(512.0, 288.0)

var _origin: Vector2 = Vector2.ZERO
var _phase: float = 0.0
var _time: float = 0.0


func _ready() -> void:
	_origin = position
	_phase = randf() * TAU
	modulate = Color(1, 1, 1, 0.75)


func _process(delta: float) -> void:
	_time += delta
	position += drift_velocity * delta
	position.y += sin(_time * drift_frequency + _phase) * drift_amplitude * delta
	if wrap_size.x > 0.0 and abs(position.x - _origin.x) > wrap_size.x:
		position.x = _origin.x
	if wrap_size.y > 0.0 and abs(position.y - _origin.y) > wrap_size.y:
		position.y = _origin.y


