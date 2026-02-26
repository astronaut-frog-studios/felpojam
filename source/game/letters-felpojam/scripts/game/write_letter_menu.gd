class_name Write_Letter extends Control

@onready var text_label: Label = $Panel/CartaMenu/label

@export var steps: Array[Choice_Resource] = []

var queue: Array[Choice_Resource] = []
var current_step: Choice_Resource
var current_text: String = ""  # texto acumulado

var typing_id: int = 0

var step1 := Choice_Resource.new(
	"my approved name is ___. And blablabla",
	["Joao", "Murilo", "Jorge"]
)

var step2 := Choice_Resource.new(
	"and I like ___",
	["coffee", "cookie", "chocolate"]
)

var step3 := Choice_Resource.new(
	" with fanta of ___ flavor",
	["uva", "laranja", "maracuja"]
)

var typing_speed: float = 0.04
var is_typing: bool = false

func _ready() -> void:
	if steps.is_empty():
		steps = [step1, step2, step3]

	for s in steps:
		queue.push_back(s)

	_next_step()

func _next_step() -> void:
	if queue.is_empty():
		#await type_text(current_text, current_text)
		text_label.text = current_text
		print("Fim! Texto final:")
		print(current_text)
		return

	current_step = queue.pop_front()
	
	var old_text := text_label.text
	print("LABEL_before:", text_label.text)
	print("OLD_before:", old_text)
	print("NEW_before:", current_text)
	if current_text.is_empty():
		current_text = current_step.text
	else:
		current_text += "\n" + current_step.text  # ou " " se preferir
	
	await type_text(old_text, current_text)
	#text_label.text = current_text
	print("\nCURRENT_TEXT:\n", current_text)
	print("\nOPTIONS:", current_step.options)

# Chame quando o jogador clicar numa opção
func choose_option(option_text: String) -> void:
	if is_typing:
		return
	
	var old_text := text_label.text
	current_text = _replace_with_choice(current_text, current_step.placeholder, option_text)
	
	#text_label.text = current_text
	await type_text(old_text, current_text)

	_next_step()

func type_text(old_text: String, text: String)-> void:
	is_typing = true

	# 1) achar o primeiro índice diferente
	var min_len = min(old_text.length(), text.length())
	var diff := 0
	while diff < min_len and old_text[diff] == text[diff]:
		diff += 1

	# 2) fixa a label na parte igual do NEW (não do old)
	text_label.text = text.substr(0, diff)

	# 3) digita o resto do NEW
	var rest := text.substr(diff)
	for ch in rest:
		text_label.text += ch
		await get_tree().create_timer(typing_speed).timeout

	is_typing = false

func _replace_with_choice(text: String, placeholder: String, to_insert: String) -> String:
	var index := text.find(placeholder)
	if index == -1:
		return text

	return text.substr(0, index) + to_insert + text.substr(index + placeholder.length())

func _on_button_button_down() -> void:
	if !is_typing:
		choose_option("Murilo")


func _on_button_2_button_down() -> void:
	if !is_typing:
		choose_option("cookie")


func _on_button_3_button_down() -> void:
	if !is_typing:
		choose_option("laranja")
