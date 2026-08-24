class_name DotHapticsInterpreter

signal amplitude_changed(value: float)
signal emphasis_triggered(amplitude: float, frequency: float)
signal frequency_changed(value: float)
signal haptic_ended

var data: DotHapticsData
var time: float = 0
var looped: bool = false

# Remaining amplitudes
var _r_amplitudes: Array = []
# Remaining frequencies
var _r_frequencies: Array = []


# Last amplitudes
var _l_amplitudes_t: float = 0
# Last frequencies
var _l_frequencies_t: float = 0

static func create_from_data(data: DotHapticsData) -> DotHapticsInterpreter:
	var h := DotHapticsInterpreter.new()
	h.data = data
	h.reset_remainings()
	return h

func _find_and_erase_latest_key(arr: Array):
	var latest
	for k in arr.duplicate():
		if time > k.time:
			latest = k
			arr.erase(k)
		elif time < k.time:
			break
	return latest

func tick(delta):
	time += delta
	var latest_ampl = _find_and_erase_latest_key(_r_amplitudes)
	var latest_freq = _find_and_erase_latest_key(_r_frequencies)
	
	# check amplitudes
	if latest_ampl != null:
		var t = latest_ampl.time
		var val = latest_ampl.amplitude
		if t != _l_amplitudes_t:
			_l_amplitudes_t = t
			amplitude_changed.emit(val)
			
			# emphasis trigger
			if latest_ampl.has("emphasis"):
				emphasis_triggered.emit(latest_ampl.emphasis.amplitude, latest_ampl.emphasis.frequency)
	
	# check frequency
	if latest_freq != null:
		var t = latest_freq.time
		var val = latest_freq.frequency
		if t != _l_frequencies_t:
			_l_frequencies_t = t
			frequency_changed.emit(val)
	
	if _r_amplitudes.size() == 0 and _r_frequencies.size() == 0:
		if looped:
			reset()
		else:
			haptic_ended.emit()

func seek(t: float):
	time = t
	reset_remainings()

func reset():
	time = 0
	reset_remainings()

func reset_remainings():
	_r_amplitudes = data.amplitudes.duplicate()
	_r_frequencies = data.frequencies.duplicate()
	_l_amplitudes_t = 0
	_l_frequencies_t = 0
