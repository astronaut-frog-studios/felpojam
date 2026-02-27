class_name DaysManager extends Node

enum State { BEGIN,EXTRA_LETTER, FEEDBACK_LETTER, CUSTOMER_LETTER, ENDED }

const show_letter_prefab = preload("res://nodes/letter/show_letter.tscn")

@export var total_days: int = 5
@export var current_day: int = 0
@export var current_points: int = 0
@export var days: Array[DayResource] = []
@export var feedback: FeedbackLetter = null
@export var mimos: Array[Control] = []

var state: State = State.BEGIN
var extra_letter: String

func start_day() -> void:
	var day := _get_current_day()
	if day == null:
		return
	
	extra_letter = day.extra_letter
	if extra_letter.is_empty():
		state = State.FEEDBACK_LETTER
	else:
		state = State.EXTRA_LETTER
		var show_letter: ShowLetter = show_letter_prefab.instantiate()
		show_letter.label.text = extra_letter
		await get_tree().create_timer(3.0).timeout
		show_letter.enable_interaction()
		show_letter.on_next_letter_click.connect(_on_next_extra_letter_click.bind(show_letter))
		return
	
	if state == State.FEEDBACK_LETTER:
		state = State.CUSTOMER_LETTER
		return

	if state == State.CUSTOMER_LETTER:
		state = State.ENDED
		return

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

func _on_next_extra_letter_click(show_letter: ShowLetter) -> void:
	extra_letter = ""
	show_letter.queue_free()
	_next_day()
