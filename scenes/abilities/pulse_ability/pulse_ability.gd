class_name PulseAbility
extends Node2D

@onready var back_gpu_particles_2d: GPUParticles2D = %BackGPUParticles2D
@onready var front_gpu_particles_2d: GPUParticles2D = %FrontGPUParticles2D

func _ready() -> void:
	back_gpu_particles_2d.emitting = true
	front_gpu_particles_2d.emitting = true
