class_name GlobDropComponent
extends Node

const GLOB_PICKUP = preload("uid://cylsmrl1pesu6")

@export_range(0, 1) var drop_rate: float = 1.0
@export var health_component: HealthComponent

func _ready() -> void:
	health_component.died.connect(_on_died)

func _on_died() -> void:
	if randf() > drop_rate:
		return
	if not owner is Node2D:
		return

	var spawn_position = (owner as Node2D).global_position
	var glob_pickup: GlobPickup = GLOB_PICKUP.instantiate()
	owner.get_parent().add_child(glob_pickup)
	glob_pickup.global_position = spawn_position
