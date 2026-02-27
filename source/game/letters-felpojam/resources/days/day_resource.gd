class_name DayResource extends Resource

@export_multiline() var extra_letter: String = "" # check for is_empty
@export var feedback_to_show: FeedbackLetter = null
@export var feedbacks: Array[Feedback] = []
@export var letters: Array[DayLetter] = []

func _init(
	_extra_letter: String = "",
	_feedback_to_show: FeedbackLetter = null,
	_feedbacks: Array[Feedback] = [],
	_letters: Array[DayLetter] = []
) -> void:
	extra_letter = _extra_letter
	feedback_to_show = _feedback_to_show
	feedbacks = _feedbacks.duplicate()
	letters = _letters.duplicate()
