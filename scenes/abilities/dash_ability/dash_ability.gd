class_name DashAbility
extends Node2D

@export var dash_line_length: int = 50

var line_point_queue: Array[Vector2]

@onready var queue_free_timer: Timer = $QueueFreeTimer
@onready var line_2d: Line2D = $Line2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent

#func _ready() -> void:
	#queue_free_timer.timeout.connect(queue_free)

func _process(_delta: float) -> void:
	line_point_queue.push_front(global_position)
	if line_point_queue.size() > dash_line_length:
		line_point_queue.pop_back()

	line_2d.clear_points()
	for point in line_point_queue:
		line_2d.add_point(point)
