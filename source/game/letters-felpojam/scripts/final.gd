extends TextureRect

@onready var player_name_label: Label = $name
@onready var button: Button = $Button2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_name_label.text = GlobalName.player_name + ","
	await get_tree().create_timer(4.0).timeout
	button.show()


func _on_button_2_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
