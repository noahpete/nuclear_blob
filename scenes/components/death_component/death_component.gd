class_name DeathComponent
extends Node2D

@export var health_component: HealthComponent
@export var sprite_atlas_texture: Texture2D
@export_group("Options")
@export var queue_free_on_death: bool = true
@export var ground_particles_on_death: bool = true
@export var body_particles_on_death: bool = true

@onready var sprite_particles: GPUParticles2D = $SpriteParticles
@onready var glob_ground_particles: GPUParticles2D = $GlobGroundParticles

func _ready() -> void:
	sprite_particles.texture = sprite_atlas_texture
	health_component.died.connect(_on_died)

func _play_death_animation() -> void:
	if body_particles_on_death:
		sprite_particles.emitting = true
	if ground_particles_on_death:
		glob_ground_particles.emitting = true
	await get_tree().create_timer(glob_ground_particles.lifetime).timeout
	if queue_free_on_death:
		queue_free()

func _on_died() -> void:
	if owner == null || not owner is Node2D:
		return

	var spawn_position = owner.global_position

	get_parent().remove_child(self)
	Main.instance.y_sort_root.add_child(self)

	global_position = spawn_position
	_play_death_animation()
