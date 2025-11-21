class_name Main
extends Node

static var instance: Main

@onready var world: Node2D = $World
@onready var y_sort_root: Node2D = $World/YSortRoot
@onready var background_effects: Node2D = $World/BackgroundEffects
@onready var light_sub_viewport: LightSubViewport = $LightSubViewport
@onready var game_camera: GameCamera = $GameCamera

func _ready() -> void:
	if instance != null:
		push_error("Only one instance of Main is allowed")
		return
	instance = self
	Events.player_died.connect(_on_player_died)

func _on_player_died(level: int) -> void:
	var tween := create_tween()
	tween.tween_property(Engine, "time_scale", 0.1, 4.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
