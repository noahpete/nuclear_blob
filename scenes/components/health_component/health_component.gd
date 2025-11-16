class_name HealthComponent
extends Node

signal died

@export var max_health: float = 10.0

var current_health: float

func _ready() -> void:
	current_health = max_health

func damage(amount: float) -> void:
	current_health = max(0, current_health - amount)
	check_death.call_deferred()

func check_death() -> void:
	if current_health == 0:
		died.emit()
		owner.queue_free()
