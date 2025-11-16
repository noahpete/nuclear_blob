class_name Rat
extends CharacterBody2D

const MAX_VELOCITY = 75

func _process(_delta: float) -> void:
	var direction = _get_direction_to_player()
	velocity = direction * MAX_VELOCITY
	move_and_slide()

func _get_direction_to_player() -> Vector2:
	if Player.instance != null:
		return (Player.instance.global_position - global_position).normalized()
	return Vector2.ZERO
