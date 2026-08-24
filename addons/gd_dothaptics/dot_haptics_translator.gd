## Translate DotHaptics's Interpret data to haptics values Godot can understand
class_name DotHapticsTranslator

var interpreter: DotHapticsInterpreter

signal haptic_changed(weak: float, strong: float)
signal haptic_ended

var base_amplitude: float = 0.0
var base_frequency: float = 0.0

var decay_active: bool = false
var decay_start_ms: int = 0
var decay_peak_amp: float = 0.0
var decay_peak_freq: float = 0.0

var emphasis_tail_sec: float = 0.18

func _init(inter: DotHapticsInterpreter) -> void:
	interpreter = inter
	interpreter.amplitude_changed.connect(_amplitude_changed)
	interpreter.frequency_changed.connect(_frequency_changed)
	interpreter.emphasis_triggered.connect(_emphasis_triggered)
	interpreter.haptic_ended.connect(_haptic_ended)

func _amplitude_changed(value: float):
	base_amplitude = value

func _frequency_changed(value: float):
	base_frequency = value

func _emphasis_triggered(amplitude: float, frequency: float):
	decay_peak_amp = amplitude
	decay_peak_freq = frequency
	decay_start_ms = interpreter.time
	decay_active = true
	
	_send(decay_peak_amp, decay_peak_freq)

func tick(delta: float):
	interpreter.tick(delta)
	var elapsed := (interpreter.time - decay_start_ms) / 1000.0
	var t := clampf(elapsed / emphasis_tail_sec, 0.0, 1.0)
	var eased := 1.0 - pow(1.0 - t, 3.0) # ease-out cubic

	var amp := lerpf(decay_peak_amp, base_amplitude, eased)
	var freq := lerpf(decay_peak_freq, base_frequency, eased)
	_send(amp, freq)
	if t >= 1.0:
		# Decay end
		decay_active = false
		_send(base_amplitude, base_frequency)

func seek(t: float):
	interpreter.seek(t)

func reset():
	interpreter.reset()

func _haptic_ended():
	haptic_ended.emit()

func _send(amplitude: float, frequency: float) -> void:
	var weak := amplitude * (1.0 - frequency)
	var strong := amplitude * frequency
	haptic_changed.emit(weak, strong)
