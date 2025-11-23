class_name Rat
extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var random_stream_player_2d_component: RandomStreamPlayer2DComponent = $RandomStreamPlayer2DComponent
@onready var visuals: Node2D = $Visuals

func _ready() -> void:
	hurtbox_component.hit.connect(_on_hit)
	health_component.died.connect(_on_died)

func _process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

func _on_hit(hitbox_component: HitboxComponent) -> void:
	for child in visuals.get_children():
		if child is FlashSpriteComponent:
			var flash_sprite: FlashSpriteComponent = child
			flash_sprite.flash()
	random_stream_player_2d_component.play_random_stream()
	health_component.damage(hitbox_component.damage)

func _on_died() -> void:
	GameState.round_kills += 1
