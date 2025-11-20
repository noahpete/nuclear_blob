class_name Rat
extends CharacterBody2D

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var visuals: Node2D = $Visuals

func _ready() -> void:
	hurtbox_component.hit.connect(_on_hit)


func _process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

func _on_hit() -> void:
	for child in visuals.get_children():
		if child is FlashSpriteComponent:
			var flash_sprite: FlashSpriteComponent = child
			flash_sprite.flash()
