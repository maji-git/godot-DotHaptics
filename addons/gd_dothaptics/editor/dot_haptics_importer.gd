@tool
extends ResourceFormatLoader
class_name DotHapticsFormatLoader

func _get_recognized_extensions():
	return ["haptic"]

func _get_resource_type(path: String):
	if path.get_extension() == "haptic":
		return "DotHapticsData"
	return ""

func _handles_type(type: StringName):
	if type == "Resource":
		return true
	return false

func _load(path: String, original_path: String, use_sub_threads: bool, cache_mode: int) -> Variant:
	var file_content = FileAccess.get_file_as_string(original_path)
	var data = JSON.parse_string(file_content)
	var d = DotHapticsData.load_from_dict(data)
	return d
