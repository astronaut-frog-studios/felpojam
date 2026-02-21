class_name GameManager extends Node

enum GameStep { BEGIN, LETTER, FREE_STAMP, POSTMARK, ENDED }  
enum SeloStep { MELTING_PAINT, DROP_PAINT, POSTMARK_PAINT }

@export var current_game_step: GameStep = GameStep.BEGIN
var current_selo_step: SeloStep = SeloStep.MELTING_PAINT

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
	current_selo_step = SeloStep.MELTING_PAINT
	var sinete: TextureRect = get_tree().get_first_node_in_group("sinete") as TextureRect
	
