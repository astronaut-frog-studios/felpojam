class_name TintaTransferData
extends Object

var default_texture: Texture2D
var melted_texture: Texture2D
var selo_texture: Texture2D
var color: Color

func _init(_default_texture: Texture2D = null, _melted_texture: Texture2D = null, _selo_texture: Texture2D = null, _color: Color = Color.WHITE) -> void:
	default_texture = _default_texture
	melted_texture = _melted_texture
	selo_texture = _selo_texture
	color = _color
