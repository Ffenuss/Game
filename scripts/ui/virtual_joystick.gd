extends Control
class_name VirtualJoystick

signal direction_changed(direction: Vector2)

@export var radius: float = 60.0
@export var deadzone: float = 0.12
@export var capture_ratio: float = 0.48

var _active_pointer: int = -1
var _base_position: Vector2 = Vector2.ZERO
var _knob_position: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_knob_position = Vector2.ZERO
	set_process_unhandled_input(true)


func _gui_input(event: InputEvent) -> void:
	_handle_input_event(event)


func _unhandled_input(event: InputEvent) -> void:
	_handle_input_event(event)


func _handle_input_event(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed and _active_pointer == -1 and _can_capture_position(touch.position):
			_active_pointer = touch.index
			_base_position = touch.position
			_update_direction(touch.position)
			accept_event()
		elif not touch.pressed and touch.index == _active_pointer:
			_reset()
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index == _active_pointer:
			_update_direction(drag.position)
			accept_event()
	elif event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		if mouse.pressed and _active_pointer == -1 and _can_capture_position(mouse.position):
			_active_pointer = 0
			_base_position = mouse.position
			_update_direction(mouse.position)
			accept_event()
		elif not mouse.pressed and _active_pointer == 0:
			_reset()
	elif event is InputEventMouseMotion and _active_pointer == 0:
		_update_direction((event as InputEventMouseMotion).position)
		accept_event()


func _can_capture_position(position: Vector2) -> bool:
	var capture_rect := get_global_rect().grow(radius * 0.75)
	if capture_rect.has_point(position):
		return true
	var viewport_width := get_viewport_rect().size.x
	return position.x <= viewport_width * capture_ratio


func _update_direction(position: Vector2) -> void:
	var delta := position - _base_position
	if delta.length() > radius:
		delta = delta.normalized() * radius
	_direction = delta / radius
	if _direction.length() < deadzone:
		_direction = Vector2.ZERO
	_knob_position = _direction * radius
	GameState.set_movement_override(_direction)
	emit_signal("direction_changed", _direction)
	queue_redraw()


func _reset() -> void:
	_active_pointer = -1
	_base_position = Vector2.ZERO
	_knob_position = Vector2.ZERO
	_direction = Vector2.ZERO
	GameState.set_movement_override(Vector2.ZERO)
	emit_signal("direction_changed", Vector2.ZERO)
	queue_redraw()


func _draw() -> void:
	var center := size * 0.5
	draw_arc(center, radius, 0.0, TAU, 48, Color(0.04, 0.05, 0.06, 0.85), 4.0, true)
	draw_circle(center, radius * 0.88, Color(0.08, 0.09, 0.11, 0.72))
	draw_arc(center + _knob_position, radius * 0.34, 0.0, TAU, 32, Color(0.65, 0.72, 0.82, 0.92), 3.0, true)
	draw_circle(center + _knob_position, radius * 0.28, Color(0.82, 0.86, 0.92, 0.78))

