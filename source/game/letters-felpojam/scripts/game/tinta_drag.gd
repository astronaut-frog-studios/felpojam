class_name TintaDrag extends TextureRect

@export var tinta : TintaResource = TintaResource.new()
@export var preview_size: Vector2 = Vector2(40,40)
@export var preview_offset: Vector2 = Vector2(20, 15)
@export var preview_mode: ExpandMode = TextureRect.EXPAND_KEEP_SIZE

func _ready() -> void:
	texture = tinta.default_texture

# triggers when you click and drag
func _get_drag_data(_position: Vector2) -> Variant:
	var preview : Control = Control.new()
	var preview_texture : TextureRect = TextureRect.new()
	
	preview_texture.texture = texture
	preview_texture.expand_mode = preview_mode # 0
	preview_texture.size = preview_size
	preview_texture.position = preview_offset - _position
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	
	visible = false
	var tinta_data: TintaTransferData = TintaTransferData.new(tinta.default_texture, tinta.melted_texture, tinta.selo_texture)
	
	return tinta_data

# triggers when fail drop, it returns to its initial position
func _notification(what:int) -> void:
	if what == NOTIFICATION_DRAG_END and not is_drag_successful():
		visible = true if !visible else visible
	if what == NOTIFICATION_DRAG_END and !visible:
		queue_free()
