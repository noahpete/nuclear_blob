class_name BackgroundGlobs
extends CanvasLayer

@onready var texture_rect: TextureRect = $TextureRect

func _process(delta: float) -> void:
	texture_rect.texture.noise.offset.y += -delta * 10
