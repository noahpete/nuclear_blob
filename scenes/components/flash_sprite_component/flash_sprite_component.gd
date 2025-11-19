class_name FlashSpriteComponent
extends Sprite2D

@export var flash_color: Color = Color.WHITE
@export var duration: float = 0.4

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.size = region_rect.size * 1.2
	color_rect.global_position = global_position - color_rect.size / 2

func flash() -> void:
	color_rect.modulate = flash_color
	color_rect.show()

	var flash_tween := create_tween()
	flash_tween.tween_property(color_rect, "modulate:a", 0.0, duration)\
		.from(1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
