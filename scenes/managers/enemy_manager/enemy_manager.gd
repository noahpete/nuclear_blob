class_name EnemyManager
extends Node

const RAT = preload("uid://wrbxwpd8qym2")
const SPAWN_RADIUS = 330

@export var enemy_container: Node

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	if Player.instance == null:
		return

	var random_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position := Player.instance.global_position + random_direction * SPAWN_RADIUS

	var enemy: Rat = RAT.instantiate()
	enemy_container.add_child(enemy)
	enemy.global_position = spawn_position
