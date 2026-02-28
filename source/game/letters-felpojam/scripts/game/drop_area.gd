extends Control

const DRAWING = preload("res://nodes/desenho_do_carimbo.tscn")

# triggers when you hover with a dragged item
func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	return data is Stamp_Drag and data is not SpoonDrag and data is not SineteDrag
	
# triggers when you drop a dragged item
func _drop_data(_position: Vector2, data: Variant) -> void:
	if name.to_lower().contains("carta"):
		_paint_letter(data)
	elif name.to_lower().contains("mesa"): 
		_return_carimbo(data)

func _paint_letter(data: Stamp_Drag) -> void:
		var desenho : TextureRect = _set_drawing(data)
		
		add_child(desenho)
		
		_return_carimbo(data)
		desenho.position = get_local_mouse_position()
		desenho.self_modulate.a = 0.8

func _return_carimbo(data: Stamp_Drag) -> void:
	data.position = data.initial_pos
	
func _set_drawing(data: Variant) -> TextureRect:
	var node : TextureRect = DRAWING.instantiate()
	node.add_to_group("stamp_draw")
	node.texture = data.get_child(0).texture
	node.get_groups()
	return node
