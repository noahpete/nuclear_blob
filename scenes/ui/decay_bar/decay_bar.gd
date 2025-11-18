class_name DecayBar
extends CanvasLayer

@export var decay_manager: DecayManager

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var spark_globs: GPUParticles2D = $SparkGlobs

func _ready() -> void:
	decay_manager.decay_updated.connect(_on_decay_updated)

func _update_progress_bar_end(percent: float) -> void:
	var start_x := progress_bar.global_position.x
	var end_x := start_x + progress_bar.size.x * percent
	var y := progress_bar.global_position.y + progress_bar.size.y / 2
	spark_globs.global_position = Vector2(end_x, y)

func _on_decay_updated(current_decay: float, target_decay: float) -> void:
	var percent := current_decay / target_decay
	progress_bar.value = percent
	_update_progress_bar_end(percent)
