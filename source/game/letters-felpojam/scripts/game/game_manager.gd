class_name GameManager extends Node

enum GameStep { BEGIN, LETTER, FREE_STAMP, POSTMARK, ENDED }  
enum SeloStep { MELTING_PAINT, DROP_PAINT, POSTMARK_PAINT }

@export var current_game_step: GameStep = GameStep.BEGIN
@export var current_selo_step: SeloStep = SeloStep.MELTING_PAINT

func _ready() -> void:
	#current_game_step = GameStep.BEGIN
	pass # Replace with function body.

func _process(_delta: float) -> void:
	match current_game_step:
		GameStep.BEGIN:
			print("begin")
		GameStep.POSTMARK:
			_postmark_step()
	pass

func _postmark_step() -> void:
	var sinete: TextureRect = get_tree().get_first_node_in_group("sinete") as TextureRect
	var spoon: TextureRect =  get_tree().get_first_node_in_group("spoon") as TextureRect

	match current_selo_step:
		SeloStep.MELTING_PAINT:
			spoon.mouse_filter = Control.MOUSE_FILTER_IGNORE
			sinete.mouse_filter = Control.MOUSE_FILTER_IGNORE
			sinete.self_modulate = Color(0.348, 0.348, 0.348, 1.0)
		SeloStep.DROP_PAINT:
			spoon.mouse_filter = Control.MOUSE_FILTER_PASS
			pass
		SeloStep.POSTMARK_PAINT:
			spoon.mouse_filter = Control.MOUSE_FILTER_IGNORE #nao está mudando
			#sinete.mouse_filter = Control.MOUSE_FILTER_PASS
			sinete.self_modulate = Color.WHITE


func _on_forninho_change_to_drop_step() -> void:
	current_selo_step = SeloStep.DROP_PAINT


func _on_selo_area_change_to_postmark_step() -> void:
	current_selo_step = SeloStep.POSTMARK_PAINT


func _on_selo_area_change_to_ended_step() -> void:
	pass # Replace with function body.
