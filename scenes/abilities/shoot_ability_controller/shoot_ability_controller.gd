class_name ShootAbilityController
extends Node

const GLOB_PROJECTILE = preload("uid://buyg2u6ftbuc4")

@onready var fire_rate_timer: Timer = $FireRateTimer

func shoot(direction: Vector2) -> void:
	if !fire_rate_timer.is_stopped():
		return

	var glob_projectile: GlobProjectile = GLOB_PROJECTILE.instantiate()
	glob_projectile.global_position = owner.global_position
	glob_projectile.initialize(direction)
	Main.instance.y_sort_root.add_child(glob_projectile, true)
	fire_rate_timer.start()
