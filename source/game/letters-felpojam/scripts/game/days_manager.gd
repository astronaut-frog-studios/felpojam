class_name DaysManager extends Node

@export var total_days: int = 5
@export var current_day: int = 0
@export var current_points: int = 0
@export var days: Array[DayResource] = []
@export var feedback: DayLetter = null

@onready var mimos: Array[Control] = [$Mimos/Mimo1, $Mimos/Mimo2, $Mimos/Mimo3, $Mimos/Mimo4]

func start_day() -> void:
	pass

func finalize_day() -> void:
	var day := _get_current_day()
	if day == null:
		return

	if current_points >= 40:
		var good_feedback: Feedback = day.feedbacks[0]
		feedback = good_feedback.content
		_show_mimo()
	else:
		var bad_feedback: Feedback = day.feedbacks[1]
		feedback = bad_feedback.content
	_next_day()

func _next_day() -> void:
	if current_day < total_days - 1:
		current_day += 1
		current_points = 0

# get day object
func _get_current_day() -> DayResource:
	if current_day >= 0 and current_day < days.size():
		return days[current_day]
	return null

func add_points(value: int) -> void:
	current_points += value

func _show_mimo() -> void:
	if current_day < mimos.size():
		mimos[current_day].show()

func add_day(day: DayResource) -> void:
	days.append(day)
	total_days = days.size()
