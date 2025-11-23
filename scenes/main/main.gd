class_name Main
extends Node

const POST_ROUND_SCREEN: PackedScene = preload("uid://38lgapsanr1h")

static var instance: Main

@onready var world: Node2D = $World
@onready var y_sort_root: Node2D = $World/YSortRoot
@onready var background_effects: Node2D = $World/BackgroundEffects
@onready var light_sub_viewport: LightSubViewport = $LightSubViewport
@onready var game_camera: GameCamera = $GameCamera
@onready var decay_bar: DecayUI = $DecayBar
@onready var decay_manager: DecayManager = $DecayManager
@onready var enemy_manager: EnemyManager = $EnemyManager

func _ready() -> void:
	if instance != null:
		push_error("Only one instance of Main is allowed")
		return
	instance = self

	GameState.round_level_reached = 0
	GameState.round_kills = 0
	GameState.round_time_msec = 0

	Events.player_died.connect(_on_player_died)
	Events.level_up.connect(_on_level_up)
	Events.upgrade_selected.connect(_on_upgrade_selected)
	await Events.player_died
	ScreenTransition.to_black()

func _on_player_died(level: int) -> void:
	GameState.round_level_reached = level
	GameState.player_data.current_xp += level
	GameState.round_time_msec = Time.get_ticks_msec()

	await get_tree().create_timer(2).timeout

	get_tree().change_scene_to_packed(POST_ROUND_SCREEN)

func _on_level_up(new_level: int) -> void:
	world.process_mode = Node.PROCESS_MODE_DISABLED
	decay_manager.process_mode = Node.PROCESS_MODE_DISABLED
	enemy_manager.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(0.2).timeout
	decay_bar.process_mode = Node.PROCESS_MODE_DISABLED
	decay_bar.spark_globs.process_mode = Node.PROCESS_MODE_PAUSABLE
	decay_bar.level_label.process_mode = Node.PROCESS_MODE_PAUSABLE
	decay_bar.animation_player.process_mode = Node.PROCESS_MODE_PAUSABLE

func _on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	world.process_mode = Node.PROCESS_MODE_PAUSABLE
	decay_bar.process_mode = Node.PROCESS_MODE_PAUSABLE
	decay_manager.process_mode = Node.PROCESS_MODE_PAUSABLE
	enemy_manager.process_mode = Node.PROCESS_MODE_PAUSABLE
