class_name GlobProjectile
extends Sprite2D

const SPEED: float = 50.0

var direction: Vector2 = Vector2.ZERO

@onready var life_timer: Timer = $LifeTimer

func _ready() -> void:
	life_timer.timeout.connect(_on_life_timer_timeout)
	_start_rotation()

func _physics_process(delta: float) -> void:
	global_position += direction * SPEED * delta

func initialize(input_direction: Vector2) -> void:
	direction = input_direction
	rotation = direction.angle()

func _start_rotation() -> void:
	var rotation_tween := create_tween()
	var rotation_amount := randi_range(-360, 360)
	rotation_tween.tween_property(self, "rotation_degrees", rotation_amount, life_timer.wait_time)

func _on_life_timer_timeout() -> void:
	queue_free()
