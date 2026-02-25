extends Control

@onready var fire: AnimatedSprite2D = $Forninho/fire
@onready var spoon_drop: TextureRect = $colher/colherDrop
@onready var spoon_drag: SpoonDrag = $colher

signal change_to_drop_step

# triggers when you hover with a dragged item
func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	return data is TintaTransferData
	
# triggers when you drop a dragged item
func _drop_data(_position: Vector2, data: Variant) -> void:
	if data is TintaTransferData:
		spoon_drag.tinta = TintaResource.new(data.default_texture, data.melted_texture, data.selo_texture, data.color)
		spoon_drop.texture = data.default_texture
		spoon_drop.modulate = data.color
		fire.visible = true

		change_to_drop_step.emit()
		await get_tree().create_timer(5.0).timeout

		spoon_drop.texture = data.melted_texture
		fire.visible = false
