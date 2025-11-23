class_name PostRoundScreen
extends Control

const MAX_LEVEL_DISPLAYED: float = 30

var main: PackedScene
var main_menu: PackedScene

@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D
@onready var liquid: Liquid = %Liquid
@onready var time_h_box_container: HBoxContainer = %TimeHBoxContainer
@onready var level_h_box_container: HBoxContainer = %LevelHBoxContainer
@onready var kills_h_box_container: HBoxContainer = %KillsHBoxContainer
@onready var restart_button: Button = %RestartButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var glob_amount_label: Label = %GlobAmountLabel

func _ready() -> void:
	main = load("uid://da36exb4ldn5o")
	main_menu = load("uid://shj0dnrasdc2")

	restart_button.pressed.connect(_on_restart_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

	time_h_box_container.get_node("Amount").text = str(int(GameState.round_time_msec/60000.0)).pad_zeros(2)+":"+str(int(GameState.round_time_msec/1000.0)).pad_zeros(2)
	level_h_box_container.get_node("Amount").text = str(GameState.round_level_reached)
	kills_h_box_container.get_node("Amount").text = str(GameState.round_kills)

	ScreenTransition.to_transparent()
	gpu_particles_2d.emitting = true
	var tween := create_tween()
	tween.tween_property(gpu_particles_2d, "position", Vector2(320, 360), 1.6)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)


	await get_tree().create_timer(2).timeout
	_update_glob_amount_label()
	liquid.splash(liquid.global_position + Vector2(liquid.liquid_size.x * randf(), 0), randi_range(150, 200) * liquid.splash_multiplier)
	gpu_particles_2d.queue_free()

	var fill_percent: float = min(1, GameState.player_data.total_xp / MAX_LEVEL_DISPLAYED)
	var position_tween := create_tween()
	position_tween.tween_property(liquid, "position:y", liquid.position.y - 40 * fill_percent, 1)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

	await get_tree().create_timer(0.5).timeout
	liquid.splash(liquid.global_position + Vector2(liquid.liquid_size.x * randf(), 0), randi_range(100, 200) * liquid.splash_multiplier)
	await get_tree().create_timer(0.5).timeout
	liquid.splash(liquid.global_position + Vector2(liquid.liquid_size.x * randf(), 0), randi_range(100, 200) * liquid.splash_multiplier)

func _update_glob_amount_label() -> void:
	for i in range(5):
		glob_amount_label.text = "%d" % (GameState.player_data.total_xp * 0.2 * (i + 1))
		await get_tree().create_timer(0.1 * i).timeout

func _on_restart_button_pressed() -> void:
	await ScreenTransition.to_black()
	get_tree().change_scene_to_packed(main)
	ScreenTransition.to_transparent()

func _on_main_menu_button_pressed() -> void:
	await ScreenTransition.to_black()
	get_tree().change_scene_to_packed(main_menu)
	ScreenTransition.to_transparent()
