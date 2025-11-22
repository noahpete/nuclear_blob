class_name HurtboxComponent
extends Area2D

signal hit(hitbox_component: HitboxComponent)

@export var health_component: HealthComponent

var shake_tween: Tween

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	hit.connect(_on_hit)

func _on_area_entered(other_area: Area2D) -> void:
	if not other_area is HitboxComponent:
		return
	var hitbox_component = other_area as HitboxComponent
	if health_component != null:
		health_component.damage(hitbox_component.damage)
	hit.emit(hitbox_component)

func _on_hit(hitbox_component: HitboxComponent) -> void:
	hitbox_component.register_hurtbox_hit(self)
