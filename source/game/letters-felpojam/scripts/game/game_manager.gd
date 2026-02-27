class_name GameManager extends Node

enum GameStep { BEGIN, LETTER, FREE_STAMP, POSTMARK, ENDED }  
enum SeloStep { MELTING_PAINT, DROP_PAINT, POSTMARK_PAINT, ENDED }

signal on_letter_delivery_end

@export var current_game_step: GameStep = GameStep.BEGIN
@export var current_selo_step: SeloStep = SeloStep.MELTING_PAINT

@onready var caixa_sinetes: SineteStorage = %CaixaSinete
@onready var envelopes: TextureButton = $"../Envelopes"
@onready var carta: Control = $"../Carta"
@onready var carta_content: Label = $"../Carta/CartaTable/CartaTableLabel"
@onready var carta_envelopada: Control = $"../CartaEnvelopada"
@onready var selo_area: Control = $"../CartaEnvelopada/envelope/SeloArea"
@onready var deliver_button: TextureButton = $"../DeliverLetter"

var spoon: SpoonDrag
var stamps: Array

var enable_stamps_run: bool = false
var disable_stamps_run: bool = false

func _ready() -> void:
	spoon = get_tree().get_first_node_in_group("spoon") as SpoonDrag
	stamps = get_tree().get_nodes_in_group("stamp") as Array[Stamp_Drag]
	current_game_step = GameStep.BEGIN
	match current_game_step:
		GameStep.BEGIN:
			print("begin")
		GameStep.POSTMARK:
			print("postmark")

func _process(_delta: float) -> void:
	if get_tree().paused:
		enable_stamps_run = false
		_enable_all_stamps()
	
	match current_game_step:
		not GameStep.POSTMARK:
			spoon.disable_interaction()
			caixa_sinetes.disable_sinete_interactions()
			caixa_sinetes.disable_tinta_interactions()
		GameStep.BEGIN:
			# etapa do inbox
			disable_stamps_run = false
			enable_stamps_run = false
			_disable_all_stamps()
		GameStep.LETTER:
			pass
		GameStep.FREE_STAMP:
			_free_stamp_step()
		GameStep.POSTMARK:
			_postmark_step()
		GameStep.ENDED:
			deliver_button.show()
			deliver_button.button_down.connect(func() -> void:
				var carimbadas := get_tree().get_nodes_in_group("stamp_draw") as Array
				for carimbada: Node in carimbadas:
					carimbada.queue_free()
				carta.show()
				carta_content.text = ""
				carta_envelopada.hide()
				disable_stamps_run = false
				selo_area.texture = null
				deliver_button.hide()
				on_letter_delivery_end.emit()
				)
			current_game_step = GameStep.BEGIN

func _free_stamp_step() -> void:
	envelopes.mouse_filter = Control.MOUSE_FILTER_PASS
	envelopes.modulate = Color.WHITE
	envelopes.get_node("Panel").show()
	_enable_all_stamps()
	# new feature: salvar carta?

func _postmark_step() -> void:
	envelopes.mouse_filter = Control.MOUSE_FILTER_IGNORE
	envelopes.get_node("Panel").hide()
	envelopes.modulate = Color("cdcdcd")
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
	if !disable_stamps_run:
		for stamp: Stamp_Drag in stamps:
			stamp.disable_interaction()
		disable_stamps_run = true

func _enable_all_stamps() -> void:
	if !enable_stamps_run:
		for stamp: Stamp_Drag in stamps:
			stamp.enable_interaction()
		enable_stamps_run = true

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

func _on_write_letter_menu_on_letter_finished(_point: int) -> void:
	current_game_step = GameStep.FREE_STAMP
