class_name Feedback extends Resource

enum Flag {
	GOOD,
	BAD
}

@export var content: DayLetter
@export var flag: Flag
@export var mimo: String

func _init(
	_content: DayLetter = null,
	_flag: Flag = Flag.GOOD,
	_mimo: String = ""
) -> void:
	content = _content
	flag = _flag
	mimo = _mimo
