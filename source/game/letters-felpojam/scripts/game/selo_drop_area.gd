extends TextureRect

@onready var panel: Panel = $Panel
@onready var desenho: TextureRect = $Desenho

signal change_to_postmark_step
signal change_to_ended_step

var tinta_selo: TintaResource

# triggers when you hover with a dragged item
func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	return (data is SpoonDrag or data is SineteDrag) and data is not Stamp_Drag
	
# triggers when you drop a dragged item
func _drop_data(_position: Vector2, data: Variant) -> void:
	if data is SpoonDrag:
		texture = data.get_child(0).texture
		tinta_selo = data.tinta
		modulate = tinta_selo.color
		
		change_to_postmark_step.emit()
		data.get_child(0).texture = null
	elif data is SineteDrag:
		texture = tinta_selo.selo_texture
		desenho.texture = data.desenho
		desenho.modulate = tinta_selo.color.darkened(0.2)#Color.hex(0x353434FF)
		data.global_position = panel.global_position - Vector2(15, 10)
		data.play_animation()
		change_to_ended_step.emit()
	panel.visible = false
