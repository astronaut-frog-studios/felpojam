extends TextureRect

@onready var panel : Panel = $Panel

signal change_to_postmark_step
signal change_to_ended_step

var tinta_selo: TintaResource

# triggers when you hover with a dragged item
func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	return data is SpoonDrag or data is SineteDrag
	
# triggers when you drop a dragged item
func _drop_data(_position: Vector2, data: Variant) -> void:
	if data is SpoonDrag:
		texture = data.get_child(0).texture
		change_to_postmark_step.emit()
		data.get_child(0).texture = null
		tinta_selo = data.tinta
	elif data is SineteDrag:
		texture = tinta_selo.selo_texture
		change_to_ended_step.emit()
		data.queue_free()
	panel.visible = false
	
