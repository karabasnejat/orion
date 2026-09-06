class_name OrionInput
extends RefCounted

static func setup() -> void:
	bind("move_left", [KEY_A, KEY_LEFT], JOY_BUTTON_DPAD_LEFT)
	bind("move_right", [KEY_D, KEY_RIGHT], JOY_BUTTON_DPAD_RIGHT)
	bind("move_down", [KEY_S, KEY_DOWN], JOY_BUTTON_DPAD_DOWN)
	bind("jump", [KEY_SPACE], JOY_BUTTON_A)
	bind("light", [KEY_J], JOY_BUTTON_X)
	bind("heavy", [KEY_K], JOY_BUTTON_Y)
	bind("dodge", [KEY_SHIFT], JOY_BUTTON_B)
	bind("heal", [KEY_E], JOY_BUTTON_LEFT_SHOULDER)
	bind("pause", [KEY_ESCAPE], JOY_BUTTON_START)
	axis("move_left", JOY_AXIS_LEFT_X, -1.0)
	axis("move_right", JOY_AXIS_LEFT_X, 1.0)
	axis("move_down", JOY_AXIS_LEFT_Y, 1.0)

static func bind(action: String, keys: Array, button: int) -> void:
	if InputMap.has_action(action):
		return
	InputMap.add_action(action, 0.25)
	for key in keys:
		var event := InputEventKey.new()
		event.physical_keycode = key
		InputMap.action_add_event(action, event)
	var joy := InputEventJoypadButton.new()
	joy.button_index = button
	InputMap.action_add_event(action, joy)

static func axis(action: String, index: int, value: float) -> void:
	var event := InputEventJoypadMotion.new()
	event.axis = index
	event.axis_value = value
	InputMap.action_add_event(action, event)
