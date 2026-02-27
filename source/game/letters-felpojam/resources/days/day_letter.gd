class_name DayLetter extends Resource

@export var content: String
@export var author: String
@export var points: int = 0

func _init(
	_content: String = "",
	_author: String = "",
	_points: int = 0
) -> void:
	content = _content
	author = _author
	points = _points
