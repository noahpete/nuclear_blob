class_name ShootAbilityController
extends Node

const GLOB = preload("uid://buyg2u6ftbuc4")

@onready var fire_rate_timer: Timer = $FireRateTimer

func shoot(direction: Vector2) -> void:
	if !fire_rate_timer.is_stopped():
		return

	var glob: Glob = GLOB.instantiate()
	glob.global_position = owner.global_position
	glob.initialize(direction)
	Main.instance.y_sort_origin.add_child(glob, true)
	fire_rate_timer.start()
