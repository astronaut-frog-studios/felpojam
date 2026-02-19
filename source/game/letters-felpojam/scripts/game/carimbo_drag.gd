extends TextureRect

# triggers when you click and drag
func _get_drag_data(_position: Vector2) -> Variant:
	var preview : Control = Control.new()
	var preview_obj : Node = Node.new()
	preview_obj = self.duplicate()
	preview_obj.remove_child(preview_obj.get_child(1))

	preview.add_child(preview_obj)
	set_drag_preview(preview)
	
	self_modulate.a = 0.0
	get_child(0).visible = false
	return get_child(0).texture

# triggers when you hover with a dragged item
func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	return data is Texture2D

# when drop in the same place, it become visible back
func _drop_data(_position: Vector2, _data: Variant) -> void:
	self_modulate.a = 1.0
	get_child(0).visible = true

# triggers when fail drop, it returns to its initial position
func _notification(what:int) -> void:
	if what == NOTIFICATION_DRAG_END:
		self_modulate.a = 1.0
		get_child(0).visible = true	
