class_name DecayUI
extends CanvasLayer

@export var decay_manager: DecayManager

var target_percent: float = 0.0

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var spark_globs: GPUParticles2D = %SparkGlobs
@onready var level_label_container: Node2D = %LevelLabelContainer
@onready var level_label: Label = %LevelLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var level_up_cooldown_timer: Timer = $LevelUpCooldownTimer

func _ready() -> void:
	target_percent = progress_bar.value
	decay_manager.decay_updated.connect(_on_decay_updated)
	Events.level_up.connect(_on_level_up)
	Events.player_died.connect(_on_player_died)

func _physics_process(delta: float) -> void:
	progress_bar.value = lerp(progress_bar.value, target_percent, delta * 10)
	_update_progress_bar_end(progress_bar.value)

func _update_progress_bar_end(percent: float) -> void:
	var start_x := progress_bar.global_position.x
	var end_x := start_x + progress_bar.size.x * percent
	var y := progress_bar.global_position.y + progress_bar.size.y / 2
	var final_position := Vector2(end_x, y)
	spark_globs.global_position = final_position
	level_label_container.global_position = final_position + Vector2(0, 2)

func _on_decay_updated(current_decay: float, target_decay: float) -> void:
	target_percent = current_decay / target_decay

func _on_level_up(new_level: int) -> void:
	level_label.text = str(new_level)

	match new_level:
		1:
			progress_bar.get_node("ShakeAnimationComponent").shake_strength = 2
		5:
			progress_bar.get_node("ShakeAnimationComponent").shake_strength = 4
		10:
			progress_bar.get_node("ShakeAnimationComponent").shake_strength = 6
		20:
			progress_bar.get_node("ShakeAnimationComponent").shake_strength = 8

	level_up_cooldown_timer.start()

func _on_player_died(level: int) -> void:
	Log.info("DecayUI: _on_player_died")
	animation_player.play("RESET")
	animation_player.seek(0.0, true)
	await get_tree().create_timer(1.0).timeout
	var center_position := get_viewport().get_visible_rect().size / 2.0
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(level_label_container, "global_position", center_position, 1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(level_label_container, "scale", Vector2(2, 2), 1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(spark_globs, "modulate:a", 0.0, 1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(progress_bar, "modulate:a", 0.0, 1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.4).timeout
	var color_tween := create_tween()
	color_tween.tween_property(level_label, "theme_override_colors/font_color", Color(0.412, 1.0, 0.831, 1.0), 0.8)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
