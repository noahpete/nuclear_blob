extends CharacterBody2D

const GLOB = preload("uid://buyg2u6ftbuc4")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: CanvasGroup = $Visuals
@onready var body_globs: GPUParticles2D = $Visuals/BodyGlobs
@onready var eyes_sprite_2d: Sprite2D = $Visuals/EyesSprite2D

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("left", "right", "up", "down")

	if input_vector.is_zero_approx():
		animation_player.play("RESET")
	else:
		animation_player.play("move")

	_update_skew(delta)
	_update_eyes(delta)
	_update_globs(delta)

	velocity = input_vector * 100
	move_and_slide()

func _update_skew(delta: float) -> void:
	var target_skew := deg_to_rad(Input.get_axis("left", "right") * 5)
	visuals.skew = lerp(visuals.skew, target_skew, delta * 10)

func _update_globs(delta: float) -> void:
	var target_position := -1 * Input.get_vector("left", "right", "up", "down") * 2
	body_globs.position = lerp(body_globs.position, target_position, delta * 10)

func _update_eyes(delta: float) -> void:
	var target_position := Input.get_vector("left", "right", "up", "down") * 2
	eyes_sprite_2d.position = lerp(eyes_sprite_2d.position, target_position, delta * 10)
