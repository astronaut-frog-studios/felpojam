@tool
extends AnimatedTextureRect
class_name SineteDrag

@export var preview_size: Vector2 = Vector2(40,40)
@export var preview_offset: Vector2 = Vector2(20, 15)
@export var preview_mode: ExpandMode = TextureRect.EXPAND_KEEP_SIZE

@export var desenho: Texture2D
@export var sinete_texture: Texture2D

var initial_pos: Vector2

func _ready() -> void:
	initial_pos = position
	disable_interaction()
	pass

# triggers when you click and drag
func _get_drag_data(_position: Vector2) -> Variant:
	var preview : Control = Control.new()
	var preview_texture : TextureRect = TextureRect.new()
	
	preview_texture.texture = texture
	preview_texture.expand_mode = preview_mode # 0]
	preview_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	preview.size = preview_size
	preview_texture.position = preview_offset - _position
	
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	hide()
	
	return self

# triggers when fail drop, it returns to its initial position
func _notification(what:int) -> void:
	if what == NOTIFICATION_DRAG_END and not is_drag_successful():
		visible = true if !visible else visible

func disable_interaction() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	self_modulate = Color(0.348, 0.348, 0.348, 1.0)
	
func enable_interaction() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	self_modulate = Color.WHITE

func play_animation() -> void:
	show()
	play("stamping")

func _on_animation_finished() -> void:
	if animation == "stamping":
		play("idle")
		position = initial_pos
