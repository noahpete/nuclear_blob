class_name Glob
extends Sprite2D

const SPEED: float = 300.0

var direction: Vector2 = Vector2.ZERO

@onready var life_timer: Timer = $LifeTimer

func _ready() -> void:
	life_timer.timeout.connect(_on_life_timer_timeout)

func _physics_process(delta: float) -> void:
	global_position += direction * SPEED * delta

func initialize(input_direction: Vector2) -> void:
	direction = input_direction
	rotation = direction.angle()

func _on_life_timer_timeout() -> void:
	queue_free()
