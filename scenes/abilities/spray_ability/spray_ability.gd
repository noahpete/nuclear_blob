class_name SprayAbility
extends Node2D

@onready var destroy_timer: Timer = $DestroyTimer
@onready var spark_globs: GPUParticles2D = %SparkGlobs
@onready var hitbox_component: HitboxComponent = $HitboxComponent

func _ready() -> void:
	spark_globs.emitting = true
	destroy_timer.timeout.connect(queue_free)
