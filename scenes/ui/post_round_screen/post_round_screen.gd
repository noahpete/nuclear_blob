class_name PostRoundScreen
extends Control

const MAX_LEVEL: float = 30

@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D
@onready var liquid: Liquid = %Liquid
@onready var time_h_box_container: HBoxContainer = %TimeHBoxContainer
@onready var level_h_box_container: HBoxContainer = %LevelHBoxContainer
@onready var kills_h_box_container: HBoxContainer = %KillsHBoxContainer

func _ready() -> void:
	time_h_box_container.get_node("Amount").text = str(int(GameState.round_time_msec/60000.0)).pad_zeros(2)+":"+str(int(GameState.round_time_msec/1000.0)).pad_zeros(2)
	level_h_box_container.get_node("Amount").text = str(GameState.round_level_reached)
	kills_h_box_container.get_node("Amount").text = str(GameState.round_kills)

	ScreenTransition.to_transparent()
	gpu_particles_2d.emitting = true
	var tween := create_tween()
	tween.tween_property(gpu_particles_2d, "position", Vector2(320, 360), 1.6)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)

	await get_tree().create_timer(1.8).timeout
	liquid.splash(liquid.global_position + Vector2(liquid.liquid_size.x * randf(), 0), randi_range(350, 400) * liquid.splash_multiplier)
	gpu_particles_2d.queue_free()

	var fill_percent: float = min(1, GameState.round_level_reached / MAX_LEVEL)
	var position_tween := create_tween()
	position_tween.tween_property(liquid, "position:y", liquid.position.y - 40 * fill_percent, 1)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

	await get_tree().create_timer(0.5).timeout
	liquid.splash(liquid.global_position + Vector2(liquid.liquid_size.x * randf(), 0), randi_range(200, 400) * liquid.splash_multiplier)
	await get_tree().create_timer(0.5).timeout
	liquid.splash(liquid.global_position + Vector2(liquid.liquid_size.x * randf(), 0), randi_range(200, 400) * liquid.splash_multiplier)
