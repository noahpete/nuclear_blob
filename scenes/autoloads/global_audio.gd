extends Node

@onready var level_up_audio_stream_player: AudioStreamPlayer = $LevelUpAudioStreamPlayer
@onready var button_audio_stream_player: AudioStreamPlayer = $ButtonAudioStreamPlayer

static func register_buttons(buttons: Array) -> void:
	for button in buttons:
		button.pressed.connect(GlobalAudio._on_button_pressed)

func _ready() -> void:
	Events.level_up.connect(_on_level_up)

func play_stream(random_stream_player_2d_component: RandomStreamPlayer2DComponent) -> void:
	random_stream_player_2d_component.reparent(Main.instance.y_sort_root)
	random_stream_player_2d_component.play_random_stream()

func _on_level_up(_new_level: int) -> void:
	if _new_level > 0:
		level_up_audio_stream_player.play()

func _on_button_pressed() -> void:
	button_audio_stream_player.play()
