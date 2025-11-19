class_name DecayBar
extends CanvasLayer

@export var decay_manager: DecayManager

var target_percent: float = 0.0

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var spark_globs: GPUParticles2D = $SparkGlobs

func _ready() -> void:
	decay_manager.decay_updated.connect(_on_decay_updated)
	target_percent = progress_bar.value

func _physics_process(delta: float) -> void:
	progress_bar.value = lerp(progress_bar.value, target_percent, delta * 10)
	_update_progress_bar_end(progress_bar.value)

func _update_progress_bar_end(percent: float) -> void:
	var start_x := progress_bar.global_position.x
	var end_x := start_x + progress_bar.size.x * percent
	var y := progress_bar.global_position.y + progress_bar.size.y / 2
	spark_globs.global_position = Vector2(end_x, y)

func _on_decay_updated(current_decay: float, target_decay: float) -> void:
	target_percent = current_decay / target_decay
