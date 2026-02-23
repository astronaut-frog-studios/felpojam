class_name TintaResource extends Resource

@export var default_texture: Texture2D
@export var melted_texture: Texture2D
@export var selo_texture: Texture2D
@export var color: Color

func _init(_default_texture: Texture2D = null, _melted_texture: Texture2D = null, _selo_texture: Texture2D = null, _color: Color = Color.WHITE) -> void:
	default_texture = _default_texture
	melted_texture = _melted_texture
	selo_texture = _selo_texture
	color = _color
	
