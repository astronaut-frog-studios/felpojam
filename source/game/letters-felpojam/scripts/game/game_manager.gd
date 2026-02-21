class_name GameManager extends Node

enum GameStep { BEGIN, LETTER, FREE_STAMP, POSTMARK, ENDED }  
enum SeloStep { MELTING_PAINT, DROP_PAINT, POSTMARK_PAINT, ENDED }

@export var current_game_step: GameStep = GameStep.BEGIN
@export var current_selo_step: SeloStep = SeloStep.MELTING_PAINT

func _ready() -> void:
	#current_game_step = GameStep.BEGIN
	match current_game_step:
		GameStep.BEGIN:
			print("begin")
		GameStep.POSTMARK:
			print("postmark")

func _process(_delta: float) -> void:
	match current_game_step:
		GameStep.BEGIN:
			pass
		GameStep.POSTMARK:
			_postmark_step()

func _postmark_step() -> void:
	var sinete: SineteDrag = get_tree().get_first_node_in_group("sinete") as SineteDrag
	var spoon: SpoonDrag =  get_tree().get_first_node_in_group("spoon") as SpoonDrag
	current_selo_step = SeloStep.MELTING_PAINT

	match current_selo_step:
		SeloStep.ENDED:
			return
		SeloStep.MELTING_PAINT:
			spoon.mouse_filter = Control.MOUSE_FILTER_IGNORE
			spoon.disable_interaction()
			sinete.disable_interaction()
		SeloStep.DROP_PAINT:
			spoon.mouse_filter = Control.MOUSE_FILTER_PASS
		SeloStep.POSTMARK_PAINT:
			spoon.mouse_filter = Control.MOUSE_FILTER_IGNORE
			sinete.enable_interaction()


func _on_forninho_change_to_drop_step() -> void:
	current_selo_step = SeloStep.DROP_PAINT

func _on_selo_area_change_to_postmark_step() -> void:
	current_selo_step = SeloStep.POSTMARK_PAINT

func _on_selo_area_change_to_ended_step() -> void:
	current_selo_step = SeloStep.ENDED
