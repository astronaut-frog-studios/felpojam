class_name Choice_Resource extends Resource

@export var text: String
@export var placeholder: String = "___"
@export var options: Array[String] = []

func _init(_text: String = "", _options: Array[String] = []) -> void:
	text = _text
	options = _options
