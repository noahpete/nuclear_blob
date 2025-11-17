class_name DashAbility
extends Node2D

@export var dash_line_length: int = 50

var line_point_queue: Array[Vector2]

@onready var destroy_timer: Timer = $DestroyTimer
@onready var line_2d: Line2D = $Line2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent

func _ready() -> void:
	destroy_timer.timeout.connect(_on_destroy_timer_timeout)
	hitbox_component.area_entered.connect(_on_hitbox_enter)

func _process(_delta: float) -> void:
	line_point_queue.push_front(global_position)
	if line_point_queue.size() > dash_line_length:
		line_point_queue.pop_back()

	line_2d.clear_points()
	for point in line_point_queue:
		line_2d.add_point(point)

func _on_destroy_timer_timeout() -> void:
	var opacity_tween := create_tween()
	opacity_tween.tween_property(self, "modulate:a", 0, 0.4)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	opacity_tween.tween_callback(queue_free)

func _on_hitbox_enter() -> void:
	print('here')
	hitbox_component.monitoring = false
	hitbox_component.monitorable = false
