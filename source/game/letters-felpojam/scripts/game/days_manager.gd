class_name DaysManager extends Node

enum State {BEGIN, EXTRA_LETTER, FEEDBACK_LETTER, CUSTOMER_LETTER, ENDED}

@onready var show_letter: ShowLetter = %ShowLetter
@onready var write_letter: Write_Letter = %Write_Letter

@export var total_days: int = 5
@export var current_day: int = 0
@export var min_points: int = 40
@export var current_points: int = 0
@export var days: Array[DayResource] = []
@export var mimos: Array[Control] = []

@export var feedback: FeedbackLetter = null
@export var state: State = State.BEGIN


var extra_letter: String
var letters_queue: Array[DayLetter]
var current_letter: DayLetter

func start_day() -> void:
	var day := _get_current_day()
	if day == null:
		return
	
	letters_queue = day.letters.duplicate()
	extra_letter = day.extra_letter
	feedback = day.feedback_to_show

	if extra_letter.is_empty():
		if day.feedback_to_show == null:
			show_customer_letter()
			return
		show_feedback_letter()
		return
	state = State.EXTRA_LETTER
	_show_letter(extra_letter, _on_next_extra_letter_click)
	
func show_feedback_letter() -> void:
	state = State.FEEDBACK_LETTER
	_show_letter(feedback.content, _on_next_feedback_letter_click)
	return

func show_customer_letter() -> void:
	state = State.CUSTOMER_LETTER
	current_letter = letters_queue.pop_front()
	_show_letter(current_letter.content, _on_next_customer_letter_click)
	return

func finalize_day() -> void:
	var day := _get_current_day()
	if day == null:
		return

	if current_points >= min_points:
		var good_feedback: Feedback = day.feedbacks[0]
		feedback = good_feedback.content
		_show_mimo()
	else:
		var bad_feedback: Feedback = day.feedbacks[1]
		feedback = bad_feedback.content
	_next_day()

func add_points(value: int) -> void:
	current_points += value

func _show_letter(letter: String, on_next_letter_click: Callable) -> void:
	show_letter.label.text = letter
	show_letter.author.text.replace("PLAYER", GlobalName.player_name)
	show_letter.show()
	await get_tree().create_timer(3.0).timeout
	show_letter.enable_interaction()
	show_letter.on_next_letter_click.connect(on_next_letter_click)

func _next_day() -> void:
	if current_day > total_days - 1:
		get_tree().change_scene_to_file("res://Scenes/final.tscn")
		return
	current_points = 0
	current_day += 1
	start_day()

# get day object
func _get_current_day() -> DayResource:
	if current_day >= 0 and current_day < days.size():
		return days[current_day]
	return null

func _show_mimo() -> void:
	if current_day < mimos.size():
		mimos[current_day].show()

func _on_next_extra_letter_click() -> void:
	extra_letter = ""
	#show_letter.hide()
	show_feedback_letter()

func _on_next_feedback_letter_click() -> void:
	feedback = null
	#show_letter.hide()
	show_customer_letter()

func _on_next_customer_letter_click() -> void:
	show_letter.hide()
	write_letter.author = current_letter.author
	write_letter.steps = current_letter.choice_steps.duplicate()
	write_letter.on_activate()
	return

func _on_letter_delivery_end() -> void:
	if letters_queue.is_empty():
		print("letters_queue is empty")
		finalize_day()
		return
	show_customer_letter()

func _add_day(day: DayResource) -> void:
	days.append(day)
	total_days = days.size()
