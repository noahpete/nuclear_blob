class_name DecayBar
extends CanvasLayer

@export var decay_manager: DecayManager

@onready var progress_bar: ProgressBar = %ProgressBar

func _ready() -> void:
	decay_manager.decay_updated.connect(_on_decay_updated)

func _on_decay_updated(current_decay: float, target_decay: float) -> void:
	var percent := current_decay / target_decay
	progress_bar.value = percent
