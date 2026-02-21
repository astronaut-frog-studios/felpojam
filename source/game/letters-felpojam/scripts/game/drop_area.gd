extends Control

const CARIMBO = preload("res://nodes/carimbo.tscn")
const DRAWING = preload("res://nodes/desenho_do_carimbo.tscn")

@export var carimboOffset : Vector2
@export var min_x : float = 80.0
@export var max_x : float = 460.0
@export var min_y : float = 26.0
@export var max_y : float = 60.0

# triggers when you hover with a dragged item
func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	return data is TextureRect and data is not SpoonDrag and data is not SineteDrag
	
# triggers when you drop a dragged item
func _drop_data(_position: Vector2, data: Variant) -> void:
	# instanciar o desenho e depois instanciar o carimbo com um offset do desenho
	if name.to_lower().contains("carta"):
		#var drawing_bounds_x : bool = get_global_mouse_position().x > global_position.x - min_x and get_global_mouse_position().x < global_position.x + max_x
		#var drawing_bounds_y : bool = get_global_mouse_position().y > position.y - min_y and get_global_mouse_position().y < position.y - max_y
		#if drawing_bounds_x:
			#_paint_letter(data)
		#else:
			#_return_carimbo(data, global_position - Vector2(-120, -300))
		_paint_letter(data)
	# instanciar só o carimbo novamente
	elif name.to_lower().contains("mesa"):
		_return_carimbo(data, Vector2.ZERO)
	data.queue_free()

func _paint_letter(data: Variant) -> void:
		var carimbo : TextureRect = _set_carimbo(data)
		var desenho : TextureRect = _set_drawing(data)
		
		get_parent().add_child(carimbo)
		add_child(desenho)
		
		carimbo.position = get_global_mouse_position() - carimboOffset
		desenho.position = get_local_mouse_position()
		desenho.self_modulate.a = 0.8

func _return_carimbo(data: Variant, new_position: Vector2) -> void:
	var carimbo : TextureRect = _set_carimbo(data)
	get_parent().add_child(carimbo)
	carimbo.position = get_global_mouse_position() if new_position == Vector2.ZERO else new_position

func _set_carimbo(data: Variant) -> TextureRect:
	var node : TextureRect = CARIMBO.instantiate()
	node.set_meta("data", data)
	node.texture = data.texture
	node.get_child(0).texture = data.get_child(0).texture
	return node
	
func _set_drawing(data: Variant) -> TextureRect:
	var node : TextureRect = DRAWING.instantiate()
	node.set_meta("data", data)
	node.texture = data.get_child(0).texture
	return node
