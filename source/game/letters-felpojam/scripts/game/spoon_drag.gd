class_name SpoonDrag extends TextureRect

@export var tinta : TintaResource
@export var preview_size: Vector2 = Vector2(40,40)
@export var preview_offset: Vector2 = Vector2(20, 15)

# triggers when you click and drag
func _get_drag_data(_position: Vector2) -> Variant:
	var c : Control = Control.new()
	var preview : Node = duplicate()
	
	c.add_child(preview)
	#preview.position = preview_offset - _position
	#preview.size = preview_size
	set_drag_preview(c)
	
	hide()
	return self

# triggers when fail drop, it returns to its initial position
func _notification(what:int) -> void:
	if what == NOTIFICATION_DRAG_END and not is_drag_successful():
		visible = true if !visible else visible
	if what == NOTIFICATION_DRAG_END and is_drag_successful():
		show()
		
func disable_interaction() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func enable_interaction() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
