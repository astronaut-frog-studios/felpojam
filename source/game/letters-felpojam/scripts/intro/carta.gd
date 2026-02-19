extends TextureRect

@onready var button: Button= $Button2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(4.0).timeout
	button.show()

func _on_continue_pressed() -> void:
	print("continue...")
	get_tree().change_scene_to_file("res://Scenes/game_core.tscn")
