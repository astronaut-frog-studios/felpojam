extends TextureRect

@onready var panel : Panel = $Panel

# triggers when you hover with a dragged item
func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	return data is SpoonDrag or data is SineteDrag
	
# triggers when you drop a dragged item
func _drop_data(_position: Vector2, data: Variant) -> void:
	panel.visible = false
	texture = data
	data = null
	
