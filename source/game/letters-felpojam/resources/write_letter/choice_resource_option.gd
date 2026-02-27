class_name Choice_Option_Resource extends Resource

@export_multiline("Choice","no_wrap") var choice: String
@export_range(0, 20, 5.0, "prefer_slider") var point: int = 5

func _init(_choice: String = "", _point: int = 5) -> void:
	choice = _choice
	point = _point
