@icon("res://addons/gd_dothaptics/editor/icons/DotHapticsData.svg")
extends Resource
class_name DotHapticsData

var data: Dictionary = {}
var amplitudes: Array = []
var frequencies: Array = []

static func load_from_dict(d: Dictionary):
	var h := DotHapticsData.new()
	h.data = d
	h.amplitudes = d.signals.continuous.envelopes.amplitude
	h.frequencies = d.signals.continuous.envelopes.frequency
	return h
