class_name ShowLetter extends Control

signal on_next_letter_click

@onready var label: Label = $Panel/CartaMenu/label
@onready var next_button: TextureButton = $Panel/next

func disable_interaction() -> void:
	next_button.disabled = true
	next_button.modulate = Color("474747ff")
	
func enable_interaction() -> void:
	next_button.disabled = false
	next_button.modulate = Color.WHITE

func _on_next_button_down() -> void:
	label.text = ""
	disable_interaction()
	on_next_letter_click.emit()
