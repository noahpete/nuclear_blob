class_name Projectile
extends CharacterBody2D

@export var lifetime: float = 5.0

var direction: Vector2 = Vector2.ZERO
var speed: float = 0.0

@onready var lifetime_timer: Timer = $LifetimeTimer

func _ready() -> void:
	if lifetime_timer:
		lifetime_timer.wait_time = lifetime
		lifetime_timer.one_shot = true
		lifetime_timer.timeout.connect(queue_free)
		lifetime_timer.start()

func _physics_process(_delta: float) -> void:
	if direction != Vector2.ZERO:
		velocity = direction * speed
		move_and_slide()

func set_direction(new_direction: Vector2, new_speed: float) -> void:
	direction = new_direction.normalized()
	speed = new_speed
	
	# Optionally rotate sprite to face direction
	if direction != Vector2.ZERO:
		rotation = direction.angle()
