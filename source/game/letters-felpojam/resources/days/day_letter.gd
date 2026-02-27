class_name DayLetter extends Resource

@export var content: String
@export var author: String
@export var points: int = 5
@export var choice_steps: Array[ChoiceResource] = []

func _init(
	_content: String = "",
	_author: String = "",
	_points: int = 5,
	_choice_steps: Array[ChoiceResource] = []
) -> void:
	content = _content
	author = _author
	points = _points
	choice_steps = _choice_steps
