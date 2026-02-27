class_name ShowLetter extends Control

@onready var label: Label = $Panel/CartaMenu/label
@onready var next_button: TextureButton = $Panel/next

func disable_interaction() -> void:
	next_button.disabled = true
	next_button.modulate = Color("474747ff")
	
func enable_interaction() -> void:
	next_button.disabled = false
	next_button.modulate = Color.WHITE
