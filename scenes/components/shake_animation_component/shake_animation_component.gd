class_name ShakeAnimationComponent
extends Node

const NOISE_GROWTH: float = 500.0

@export var noise_texture: FastNoiseLite
@export var shake_strength: float = 8.0

var original_position: Vector2
var noise_offset_x: float
var noise_offset_y: float
var current_shake_percentage: float = 1.0

func _ready() -> void:
	var parent := get_parent()
	if parent == null:
		return
	if parent is Control:
		original_position = (parent as Control).position
	if parent is Node2D:
		original_position = (parent as Node2D).position

func _process(delta: float) -> void:
	if current_shake_percentage == 0:
		return

	noise_offset_x += NOISE_GROWTH * delta
	noise_offset_y += NOISE_GROWTH * delta

	var offset_sample_x := noise_texture.get_noise_2d(noise_offset_x, 0)
	var offset_sample_y := noise_texture.get_noise_2d(0, noise_offset_y)

	var parent := get_parent()
	if parent == null:
		return
	if parent is Control:
		(parent as Control).position = original_position + Vector2(offset_sample_x, offset_sample_y) * shake_strength
	elif parent is Camera2D:
		(parent as Camera2D).offset = Vector2(offset_sample_x, offset_sample_y) * shake_strength
	elif parent is Node2D:
		(parent as Node2D).position = original_position + Vector2(offset_sample_x, offset_sample_y) * shake_strength
