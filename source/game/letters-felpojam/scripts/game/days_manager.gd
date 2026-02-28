class_name DaysManager extends Node

enum State {BEGIN, EXTRA_LETTER, FEEDBACK_LETTER, CUSTOMER_LETTER, ENDED}

@onready var show_letter: ShowLetter = %ShowLetter
@onready var write_letter: Write_Letter = %WriteLetterMenu
@onready var inbox_button: TextureButton = $"../InboxButton"

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
var show_next_letter: bool = false

func start_day() -> void:
	var day := _get_current_day()
	if day == null:
		return
		
	current_points = 0
	letters_queue = day.letters.duplicate()
	extra_letter = day.extra_letter

	if extra_letter.is_empty():
		if feedback == null:
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
	_next_day()
	
	var day := _get_current_day()
	if day == null:
		return
		
	if current_points >= min_points:
		var good_feedback: Feedback = day.feedbacks[0]
		print("good feedback")
		feedback = good_feedback.content
		_show_mimo()
	else:
		var bad_feedback: Feedback = day.feedbacks[1]
		feedback = bad_feedback.content
		print("bad feedback")

	show_next_letter = false
	inbox_button.modulate = Color.WHITE
	inbox_button.mouse_filter = Control.MOUSE_FILTER_PASS

func add_points(value: int) -> void:
	current_points += value

func _show_letter(letter: String, on_next_letter_click: Callable) -> void:
	for signal_a in show_letter.on_next_letter_click.get_connections():
		show_letter.on_next_letter_click.disconnect(signal_a.callable)
	var new_letter := letter.replace("PLAYER", GlobalName.player_name)
	show_letter.label.text = new_letter.format({"n": "\\n"})
	show_letter.show()
	await get_tree().create_timer(1.5).timeout
	show_letter.enable_interaction()
	show_letter.on_next_letter_click.connect(on_next_letter_click)

func _next_day() -> void:
	if current_day > total_days - 1:
		get_tree().change_scene_to_file("res://Scenes/final.tscn")
		return
	current_day += 1
	feedback = null

# get day object
func _get_current_day() -> DayResource:
	if current_day >= 0 and current_day < days.size():
		return days[current_day]
	return null

func _show_mimo() -> void:
	if current_day < mimos.size():
		mimos[current_day - 1].show()

func _on_next_extra_letter_click() -> void:
	extra_letter = ""
	show_letter.hide()
	if feedback == null:
		show_customer_letter()
	else:
		show_feedback_letter()

func _on_next_feedback_letter_click() -> void:
	feedback = null
	show_letter.hide()
	show_customer_letter()

func _on_next_customer_letter_click() -> void:
	current_points = 0
	show_letter.hide()
	write_letter.author = current_letter.author
	write_letter.steps = current_letter.choice_steps.duplicate()
	write_letter.on_activate()
	return

func _on_letter_delivery_end() -> void:
	if letters_queue.is_empty():
		print("letters_queue is empty on delivery end")
		finalize_day()
		return
	show_next_letter = true
	inbox_button.modulate = Color.WHITE
	inbox_button.mouse_filter = Control.MOUSE_FILTER_PASS

func _add_day(day: DayResource) -> void:
	days.append(day)
	total_days = days.size()


func _on_inbox_button_button_down() -> void:
	if show_next_letter:
		show_customer_letter()
		show_next_letter = false
	else:
		start_day()
	inbox_button.modulate = Color(0.569, 0.569, 0.569, 1.0)
	inbox_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
