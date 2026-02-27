class_name DayLetter extends Resource

@export var content: String
@export var author: String
@export var points: int = 5

func _init(
	_content: String = "",
	_author: String = "",
	_points: int = 5
) -> void:
	content = _content
	author = _author
	points = _points
