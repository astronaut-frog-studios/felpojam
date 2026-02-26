class_name GameManager extends Node

enum GameStep { BEGIN, LETTER, FREE_STAMP, POSTMARK, ENDED }  
enum SeloStep { MELTING_PAINT, DROP_PAINT, POSTMARK_PAINT, ENDED }

@export var current_game_step: GameStep = GameStep.BEGIN
@export var current_selo_step: SeloStep = SeloStep.MELTING_PAINT

@onready var caixa_sinetes: SineteStorage = %CaixaSinete
@onready var envelopes: TextureButton = $"../Envelopes"
@onready var carta: Control = $"../Carta"
@onready var carta_content: Label = $"../Carta/CartaTable/CartaTableLabel"
@onready var carta_envelopada: Control = $"../CartaEnvelopada"

var spoon: SpoonDrag
var stamps: Array

func _ready() -> void:
	spoon = get_tree().get_first_node_in_group("spoon") as SpoonDrag
	stamps = get_tree().get_nodes_in_group("stamp") as Array[Stamp_Drag]
	#current_game_step = GameStep.BEGIN
	match current_game_step:
		GameStep.BEGIN:
			print("begin")
		GameStep.POSTMARK:
			print("postmark")

func _process(_delta: float) -> void:
	if get_tree().paused:
		_enable_all_stamps()
	
	match current_game_step:
		not GameStep.POSTMARK:
			spoon.disable_interaction()
			caixa_sinetes.disable_sinete_interactions()
			caixa_sinetes.disable_tinta_interactions()
		GameStep.BEGIN:
			# etapa do inbox
			_disable_all_stamps()
		GameStep.LETTER:
			pass
		GameStep.FREE_STAMP:
			_free_stamp_step()
		GameStep.POSTMARK:
			_postmark_step()
		GameStep.ENDED:
			carta.show()
			carta_content.text = ""
			carta_envelopada.hide()
			# seloArea.texture = null
			# aparece o bottao de Entregar carta
			# ao clicar escurece e carrega a próxima cena que estiver nele
			# recebe o nome da cena como parametro
			_disable_all_stamps()
			pass

func _free_stamp_step() -> void:
	envelopes.mouse_filter = Control.MOUSE_FILTER_PASS
	_enable_all_stamps()
	# new feature: salvar carta?

func _postmark_step() -> void:
	envelopes.mouse_filter = Control.MOUSE_FILTER_IGNORE
	match current_selo_step:
		SeloStep.ENDED:
			current_game_step = GameStep.ENDED
			spoon.disable_interaction()
			caixa_sinetes.disable_sinete_interactions()
			caixa_sinetes.disable_tinta_interactions()
			return
		SeloStep.MELTING_PAINT:
			spoon.disable_interaction()
			caixa_sinetes.enable_tinta_interactions()
			caixa_sinetes.disable_sinete_interactions()
		SeloStep.DROP_PAINT:
			caixa_sinetes.disable_tinta_interactions()
			spoon.enable_interaction()
		SeloStep.POSTMARK_PAINT:
			spoon.disable_interaction()
			caixa_sinetes.enable_sinete_interactions()

func _disable_all_stamps() -> void:
	var x: int = 0
	while x < 1:
		if x == 1:
			break
		for stamp: Stamp_Drag in stamps:
			stamp.disable_interaction()
		x+=1

func _enable_all_stamps() -> void:
	var x: int = 0
	while x < 1:
		if x == 1:
			break
		for stamp: Stamp_Drag in stamps:
			stamp.enable_interaction()
			stamp.show()
		x+=1

func _on_forninho_change_to_drop_step() -> void:
	current_selo_step = SeloStep.DROP_PAINT

func _on_selo_area_change_to_postmark_step() -> void:
	current_selo_step = SeloStep.POSTMARK_PAINT

func _on_selo_area_change_to_ended_step() -> void:
	current_selo_step = SeloStep.ENDED

func _on_envelopes_button_down() -> void:
	carta.hide()
	carta_envelopada.show()
	current_game_step = GameStep.POSTMARK
