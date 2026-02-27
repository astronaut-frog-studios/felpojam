class_name ChoiceResource extends Resource

@export_multiline("Content") var text: String
@export var placeholder: String = "___"
@export var options: Array[Choice_Option_Resource] = []

func _init(_text: String = "", _options: Array[Choice_Option_Resource] = []) -> void:
	text = _text
	options = _options
