extends CanvasLayer

@onready var texture_rect: TextureRect = $TextureRect

func to_transparent() -> void:
	show()
	var tween := create_tween()
	tween.tween_method(_set_gradient_offset.bind(0), 1.0, 0.0, 1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_method(_set_gradient_offset.bind(1), 1.0, 0.0, 1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	await tween.finished
	hide()

func to_black() -> void:
	show()
	var tween := create_tween()
	tween.tween_method(_set_gradient_offset.bind(1), 0.0, 1.0, 1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_method(_set_gradient_offset.bind(0), 0.0, 1.0, 1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	await tween.finished

func _set_gradient_offset(value: float, index: int) -> void:
	var gradient: Gradient = (texture_rect.texture as NoiseTexture2D).color_ramp
	gradient.offsets[index] = value
