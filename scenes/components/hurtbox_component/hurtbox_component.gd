class_name HurtboxComponent
extends Area2D

signal hit

@export var health_component: HealthComponent
@export_group("Options")
@export var flash_visuals_on_hit: bool = true
@export var shake_camera_on_hit: bool = true

var shake_tween: Tween

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	hit.connect(_on_hit)

func _on_area_entered(other_area: Area2D) -> void:
	if not other_area is HitboxComponent:
		return
	if health_component == null:
		return

	var hitbox_component = other_area as HitboxComponent
	health_component.damage(hitbox_component.damage)

	hit.emit()

func _on_hit() -> void:
	if shake_camera_on_hit:
		if shake_tween != null and shake_tween.is_running():
			shake_tween.kill()
		shake_tween = create_tween()
		shake_tween.tween_property(Main.instance.game_camera.shake_animation_component, "current_shake_percentage", 0.0, 0.4)\
			.from(1.0)
