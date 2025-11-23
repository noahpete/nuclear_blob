class_name MainMenu
extends Control

const MAIN: PackedScene = preload("uid://da36exb4ldn5o")

@onready var title_label: Label = %TitleLabel
@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	GlobalAudio.register_buttons([
		play_button,
		quit_button
	])

func _on_play_button_pressed() -> void:
	await ScreenTransition.to_black()
	get_tree().change_scene_to_packed(MAIN)
	ScreenTransition.to_transparent()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
