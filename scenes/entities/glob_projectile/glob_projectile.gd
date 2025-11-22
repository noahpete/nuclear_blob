class_name GlobProjectile
extends Sprite2D

var velocity: int = 200
var direction: Vector2 = Vector2.ZERO

@onready var life_timer: Timer = $LifeTimer
@onready var light: Light = $Light
@onready var hitbox_component: HitboxComponent = $HitboxComponent

func _ready() -> void:
	_grow()
	_start_rotation()
	life_timer.timeout.connect(_on_life_timer_timeout)
	hitbox_component.hit_hurtbox.connect(_on_hit_hurtbox)

func _physics_process(delta: float) -> void:
	global_position += direction * velocity * delta

func initialize(input_direction: Vector2) -> void:
	direction = input_direction
	rotation = direction.angle()

func _start_rotation() -> void:
	var rotation_tween := create_tween()
	var rotation_amount := randi_range(-360, 360)
	rotation_tween.tween_property(self, "rotation_degrees", rotation_amount, life_timer.wait_time)

func _grow() -> void:
	var opacity_tween := create_tween()
	opacity_tween.tween_property(light, "energy", 1, 0.2)\
		.from(0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

	var scale_tween := create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE * 1.8, 0.1)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)
	await scale_tween.finished
	scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE, 0.2)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)
	await scale_tween.finished

func _shrink() -> void:
	var opacity_tween := create_tween()
	opacity_tween.tween_property(light, "energy", 0, 1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

	var scale_tween := create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ZERO, 1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)
	await scale_tween.finished

func _on_life_timer_timeout() -> void:
	await _shrink()
	queue_free()

func _on_hit_hurtbox(_hurtbox_component: HurtboxComponent) -> void:
	queue_free()
