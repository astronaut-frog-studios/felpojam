extends Control

@onready var button: Button= $Button2

func _on_animated_texture_rect_enable_continue() -> void:
	button.show()


func _on_button_pressed() -> void:
	AudioManager.trocar_musica_solicitado.emit(2)
	get_tree().change_scene_to_file("res://scenes/game_core.tscn")
