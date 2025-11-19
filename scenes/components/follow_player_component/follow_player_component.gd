class_name FollowPlayerComponent
extends Node

const MAX_VELOCITY: int = 75

@export var animation_player: AnimationPlayer
@export var visuals: Node2D
@export var flip_visuals: bool

var parent: CharacterBody2D

func _ready() -> void:
	assert(get_parent() != null and get_parent() is CharacterBody2D)
	parent = get_parent()

func _process(_delta: float) -> void:
	var direction = _get_direction_to_player()
	parent.velocity = direction * MAX_VELOCITY
	if animation_player.has_animation("move") and parent.velocity.is_zero_approx():
		animation_player.play("RESET")
	else:
		animation_player.play("move")

	var move_sign = sign(parent.velocity.x) * -1 if flip_visuals else 1
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

	parent.move_and_slide()

func _get_direction_to_player() -> Vector2:
	if Player.instance != null:
		return (Player.instance.global_position - parent.global_position).normalized()
	return Vector2.ZERO
