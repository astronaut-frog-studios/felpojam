extends TextureRect

# triggers when you hover with a dragged item
func _can_drop_data(position: Vector2, data: Variant) -> bool:
	return data is Texture2D
	
# triggers when you drop a dragged item
func _drop_data(position: Vector2, data: Variant) -> void:
	texture = data
