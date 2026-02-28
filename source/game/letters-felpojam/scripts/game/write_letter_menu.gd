class_name Write_Letter extends Control

const choice_prefab = preload("res://nodes/letter/choice.tscn")

signal on_letter_finished(point: int)

@onready var text_label: Label = $Panel/CartaMenu/label
@onready var choice_container: Control = $Panel/ChoicesContainer/ChoiceContainer/ChoiceWrapper
@onready var next_button: TextureButton = $Panel/next

@export var table_letter: Label
@export var steps: Array[ChoiceResource] = []
@export var author: String = ""

var queue: Array[ChoiceResource] = []
var current_step: ChoiceResource
var current_text: String = "" # texto acumulado
var letter_points: int = 0

var typing_id: int = 0
var typing_speed: float = 0.01
var is_typing: bool = false

var step1 := ChoiceResource.new(
	"my approved name is ___. And blablabla",
	[
		Choice_Option_Resource.new("Joao", 0),
		Choice_Option_Resource.new("Murilo", 5),
		Choice_Option_Resource.new("Jorge", 10)
	]
)

var step2 := ChoiceResource.new(
	"and I like ___",
	[
	Choice_Option_Resource.new("coffee", 10),
	Choice_Option_Resource.new("cookie", 30),
	Choice_Option_Resource.new("chocolate", 5)
	]
)

var step3 := ChoiceResource.new(
	" with fanta of ___ flavor",
	[
		Choice_Option_Resource.new("uva", 15),
		Choice_Option_Resource.new("laranja", 25),
		Choice_Option_Resource.new("maracuja", 10)
	]
)

func on_activate() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED
	restart_letter(true)
	show()

func _ready() -> void:
	# FOR TEST ONLY
	if steps.is_empty():
		mouse_filter = Control.MOUSE_FILTER_PASS
		mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED
		steps = [step1, step2, step3]

	queue = steps.duplicate()
	_next_step()

func _next_step() -> void:
	if queue.is_empty():
		text_label.text = current_text + "\n" + author
		is_typing = false
		next_button.disabled = false
		next_button.modulate = Color.WHITE
		return

	current_step = queue.pop_front()
	
	var old_text := text_label.text
	if current_text.is_empty():
		current_text = current_step.text
	else:
		current_text += " " + current_step.text # trocar por " "
	
	await type_text(old_text, current_text)
	#text_label.text = current_text
	_instantiate_choices(current_step.options)

func choose_option(option_text: String, option_point: int) -> void:
	if is_typing:
		return
	
	_disable_choices()
	letter_points += option_point
	var old_text := text_label.text
	current_text = _replace_with_choice(current_text, current_step.placeholder, option_text)
	#text_label.text = current_text
	await type_text(old_text, current_text)

	_next_step()

func type_text(old_text: String, text: String) -> void:
	typing_id += 1
	var my_id := typing_id
	is_typing = true

	var index := 0
	while index < old_text.length() and old_text[index] == text[index]:
		index += 1 # o index tem que ser menor que o length e só soma enquando os indexes dos dois forem iguais (ate o limite da frase)

	text_label.text = text.substr(0, index) # a label vai ter o valor de 0 até o index do novo texto
	var rest := text.substr(index) # do index do texto pra frente vai escrever
	for character in rest:
		if my_id != typing_id:
			return # breaks loop
		text_label.text += character
		await get_tree().create_timer(typing_speed).timeout

	if my_id == typing_id:
		is_typing = false

func _instantiate_choices(options: Array[Choice_Option_Resource]) -> void:
	_clear_choices()
	for option in options:
		var choice := choice_prefab.instantiate()
		choice_container.add_child(choice)

		var btn: Button = choice.get_node("Button")
		var option_text: String = option.choice
		btn.text = option_text
		btn.button_down.connect(func() -> void:
			choose_option(option_text, option.point)
		)

func _clear_choices() -> void:
	for child in choice_container.get_children():
		child.queue_free()

func _disable_choices() -> void:
	for child in choice_container.get_children():
		var button := child.get_node_or_null("Button")
		if button:
			button.disabled = true

func restart_letter(activate: bool = false) -> void:
	if !activate:
		typing_id += 1
		is_typing = false
	
	letter_points = 0
	next_button.disabled = true
	next_button.modulate = Color("474747ff")
	current_text = ""
	current_step = null
	text_label.text = ""
	_clear_choices()
	queue.clear()
	queue = steps.duplicate()

	_next_step()

func _replace_with_choice(text: String, placeholder: String, to_insert: String) -> String:
	var index := text.find(placeholder)
	if index == -1:
		return text

	return text.substr(0, index) + to_insert + text.substr(index + placeholder.length())

func _on_reset_button_down() -> void:
	restart_letter()

func _on_next_button_down() -> void:
	table_letter.text = current_text
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	on_letter_finished.emit(letter_points)
	author = ""
	hide()
