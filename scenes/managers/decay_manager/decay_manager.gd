class_name DecayManager
extends Node

@onready var timer: Timer = $Timer

func get_decay() -> float:
	return timer.wait_time - timer.time_left
