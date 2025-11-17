class_name UI
extends CanvasLayer

@export var decay_manager: DecayManager

@onready var label: Label = %Label

func _process(_delta: float) -> void:
	if decay_manager != null:
		pass

func format_seconds_to_string(seconds: float) -> String:
	var minutes = floor(seconds / 60)
	var remaining_seconds = seconds - (minutes * 60)
	return "%d:" % minutes + "%02d" % floor(remaining_seconds)
