class_name DayLetter extends Resource

@export_multiline("Content")var content: String
@export var author: String
@export var choice_steps: Array[ChoiceResource] = []

func _init(
	_content: String = "",
	_author: String = "",
	_choice_steps: Array[ChoiceResource] = []
) -> void:
	content = _content
	author = _author
	choice_steps = _choice_steps
