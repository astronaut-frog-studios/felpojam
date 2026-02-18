extends Control

@onready var line_edit: LineEdit = $LineEdit
@onready var botao: Button = $Button

func _ready() -> void:
	botao.disabled = true
	line_edit.text_changed.connect(_set_button_enabled)
	line_edit.text_submitted.connect(_on_lineEdit_text_entered)
	
func _process(_delta: float) -> void:
	if line_edit.text.is_empty():
		botao.disabled = true
	
func _on_lineEdit_text_entered(new_text: String) -> void:
	GlobalName.player_name = new_text
	botao.disabled = false
	print(GlobalName.player_name)
	
func _set_button_enabled(_val: String) -> void:
	botao.disabled = false


func _on_button_pressed() -> void:
	GlobalName.player_name = line_edit.text
	print(GlobalName.player_name)
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
