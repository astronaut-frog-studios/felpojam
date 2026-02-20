extends Control

@onready var panel: Panel = $colher/Panel
@onready var fire: AnimatedSprite2D = $Forninho/fire
@onready var spoon_drop: TextureRect = $colher/colherDrop
@onready var spoon_drag: SpoonDrag = $colher

func _ready() -> void:
	spoon_drag.mouse_filter = Control.MOUSE_FILTER_IGNORE

# triggers when you hover with a dragged item
func _can_drop_data(_position: Vector2, data: Variant) -> bool:
	return data is TintaTransferData
	
# triggers when you drop a dragged item
func _drop_data(_position: Vector2, data: Variant) -> void:
	if data is TintaTransferData:
		spoon_drag.tinta = TintaResource.new(data.default_texture, data.melted_texture, data.selo_texture)
		spoon_drop.texture = data.default_texture
		panel.visible = false
		fire.visible = true
		await get_tree().create_timer(5.0).timeout
		
		spoon_drag.mouse_filter = Control.MOUSE_FILTER_PASS
		spoon_drop.texture = data.melted_texture
		fire.visible = false
