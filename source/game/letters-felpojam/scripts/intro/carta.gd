extends TextureRect

@onready var button: Button = $Button2
@onready var book: Control = $"../LivroTeste"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(4.0).timeout
	button.show()

func _on_continue_pressed() -> void:
	hide()
	book.show()
