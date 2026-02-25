class_name Stamp_Drag extends TextureRect

# triggers when you click and drag
func _get_drag_data(_position: Vector2) -> Variant:
	var c : Control = Control.new()
	var preview : Node = duplicate()
	c.add_child(preview)	
	preview.position = -Vector2(20,25)
	set_drag_preview(c)
	hide()
	return self

# triggers when fail drop, it returns to its initial positionx
func _notification(what:int) -> void:
	if what == NOTIFICATION_DRAG_END and is_drag_successful():
		show()

func disable_interaction() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	modulate = Color(0.348, 0.348, 0.348, 1.0)
	
func enable_interaction() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	modulate = Color.WHITE
