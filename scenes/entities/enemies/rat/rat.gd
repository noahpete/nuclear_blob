class_name Rat
extends CharacterBody2D

const MAX_VELOCITY = 75

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var visuals: Node2D = $Visuals

func _ready() -> void:
	hurtbox_component.hit.connect(_on_hit)

func _process(_delta: float) -> void:
	var direction = _get_direction_to_player()
	velocity = direction * MAX_VELOCITY
	if velocity.is_zero_approx():
		animation_player.play("RESET")
	else:
		animation_player.play("move")

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

	move_and_slide()

func _get_direction_to_player() -> Vector2:
	if Player.instance != null:
		return (Player.instance.global_position - global_position).normalized()
	return Vector2.ZERO

func _on_hit() -> void:
	for child in visuals.get_children():
		if child is FlashSpriteComponent:
			var flash_sprite: FlashSpriteComponent = child
			flash_sprite.flash()
