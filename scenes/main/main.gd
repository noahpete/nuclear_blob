class_name Main
extends Node

const POST_ROUND_SCREEN: PackedScene = preload("uid://38lgapsanr1h")

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

	GameState.round_level_reached = 0
	GameState.round_kills = 0
	GameState.round_time_msec = 0

	Events.player_died.connect(_on_player_died)
	await Events.player_died
	ScreenTransition.to_black()

func _on_player_died(level: int) -> void:
	GameState.round_level_reached = level
	GameState.round_time_msec = Time.get_ticks_msec()

	await get_tree().create_timer(2).timeout

	get_tree().change_scene_to_packed(POST_ROUND_SCREEN)
