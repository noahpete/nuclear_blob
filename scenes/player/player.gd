extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("left", "right", "up", "down")

	if input_vector.is_zero_approx():
		animation_player.play("RESET")
	else:
		animation_player.play("move")
	_update_skew(delta)

	velocity = input_vector * 100
	move_and_slide()

func _update_skew(delta: float) -> void:
	var target_skew := deg_to_rad(Input.get_axis("left", "right") * 5)
	sprite_2d.skew = lerp(sprite_2d.skew, target_skew, delta * 10.0)
