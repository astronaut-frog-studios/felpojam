class_name SineteStorage extends TextureRect

var sinetes: Array
var tintas: Array

func _ready() -> void:
	sinetes = get_tree().get_nodes_in_group("sinete") as Array[SineteDrag]
	tintas = get_tree().get_nodes_in_group("paint") as Array[TintaDrag]

func enable_sinete_interactions() -> void:
	for sinete: SineteDrag in sinetes:
		sinete.enable_interaction()
	
func disable_sinete_interactions() -> void:
	for sinete: SineteDrag in sinetes:
		sinete.disable_interaction()
		
func enable_tinta_interactions() -> void:
	for tinta: TintaDrag in tintas:
		tinta.enable_interaction()
	
func disable_tinta_interactions() -> void:
	for tinta: TintaDrag in tintas:
		tinta.disable_interaction()
