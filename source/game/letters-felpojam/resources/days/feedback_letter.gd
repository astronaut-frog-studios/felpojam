class_name FeedbackLetter extends Resource

@export_multiline() var content: String
@export var author: String

func _init(
	_content: String = "",
	_author: String = "",
) -> void:
	content = _content
	author = _author
