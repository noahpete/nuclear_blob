class_name PulseAbility
extends Node2D

@export var knockback_amount: float = 200.0

@onready var destroy_timer: Timer = $DestroyTimer
@onready var back_gpu_particles_2d: GPUParticles2D = %BackGPUParticles2D
@onready var front_gpu_particles_2d: GPUParticles2D = %FrontGPUParticles2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent

func _ready() -> void:
	back_gpu_particles_2d.emitting = true
	front_gpu_particles_2d.emitting = true
	destroy_timer.timeout.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(_on_hit_hurtbox)

func _on_hit_hurtbox(hurtbox_component: HurtboxComponent) -> void:
	var enemy := hurtbox_component.owner as Node2D
	if enemy == null:
		return

	var knockback_direction := global_position.direction_to(enemy.global_position)
	var velocity_component: VelocityComponent = enemy.get_node_or_null("VelocityComponent")
	if velocity_component:
		velocity_component.velocity += knockback_direction * knockback_amount
