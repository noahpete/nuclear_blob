class_name EnemyManager
extends Node

const RAT = preload("uid://wrbxwpd8qym2")
const SPAWN_RADIUS = 330

@export var enemy_container: Node

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func get_spawn_position() -> Vector2:
	if Player.instance == null:
		return Vector2.ZERO

	var spawn_position := Vector2.ZERO
	var random_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))

	for i in range(4):
		spawn_position = Player.instance.global_position + random_direction * SPAWN_RADIUS
		var raycast_query_parameters := PhysicsRayQueryParameters2D.create(Player.instance.global_position, spawn_position, 1)
		var raycast_result := get_tree().root.world_2d.direct_space_state.intersect_ray(raycast_query_parameters)
		if raycast_result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))

	return spawn_position

func _on_timer_timeout() -> void:
	if Player.instance == null:
		return

	var enemy: Rat = RAT.instantiate()
	enemy.global_position = get_spawn_position()
	enemy_container.add_child(enemy, true)
