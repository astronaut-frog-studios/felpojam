extends TextureRect

# triggers when you click and drag
func _get_drag_data(_position: Vector2) -> Variant:
	var c : Control = Control.new()
	var preview : Node = duplicate()
	#preview.remove_child(preview.get_child(1))
	c.add_child(preview)
	
	preview.position = -Vector2(20,25)
	set_drag_preview(c)
	
	self_modulate.a = 0.0
	get_child(0).visible = false
	return self

# triggers when fail drop, it returns to its initial positionx
func _notification(what:int) -> void:
	if what == NOTIFICATION_DRAG_END and not is_drag_successful():
		self_modulate.a = 1.0
		get_child(0).visible = true
