class_name HitboxComponent
extends Area2D

signal hit_hurtbox(hurtbox_component: HurtboxComponent)

@export var damage: int = 0

func register_hurtbox_hit(hurtbox_component: HurtboxComponent) -> void:
	hit_hurtbox.emit(hurtbox_component)
