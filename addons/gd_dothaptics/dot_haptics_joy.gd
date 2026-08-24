@icon("res://addons/gd_dothaptics/editor/icons/DotHapticsJoy.svg")
extends Node
## DotHapticsJoy is a class that trigger a .haptic file to a specific device
class_name DotHapticsJoy

@export var haptic: DotHapticsData:
	get:
		return haptic
	set(value):
		haptic = value
		if translator != null:
			translator.haptic_changed.disconnect(_haptic_changed)
			translator.haptic_ended.disconnect(_haptic_ended)
		interpreter = DotHapticsInterpreter.create_from_data(haptic)
		translator = DotHapticsTranslator.new(interpreter)
		translator.haptic_changed.connect(_haptic_changed)
		translator.haptic_ended.connect(_haptic_ended)
		interpreter.looped = looped

@export var looped: bool:
	get:
		return looped
	set(value):
		looped = value
		if interpreter:
			interpreter.looped = looped

@export var device_id: int = 0

var interpreter: DotHapticsInterpreter
var translator: DotHapticsTranslator
var is_triggering := false

func _ready() -> void:
	set_process(false)

func trigger():
	interpreter.reset()
	set_process(true)
	is_triggering = true

func seek(t: float):
	interpreter.seek(t)

func reset():
	interpreter.reset()

func stop():
	is_triggering = false
	set_process(false)
	Input.stop_joy_vibration(device_id)
	interpreter.reset()

func _process(delta: float) -> void:
	if not is_triggering: return
	translator.tick(delta)

func _haptic_changed(weak: float, strong: float):
	if not is_triggering: return
	Input.start_joy_vibration(device_id, weak, strong)

func _haptic_ended():
	stop()
