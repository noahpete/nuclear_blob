class_name Rat
extends CharacterBody2D

const GLOB_GROUND_PARTICLES = preload("uid://c7tf3jq0t4lv0")
const MAX_VELOCITY = 75

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals: Node2D = $Visuals

func _ready() -> void:
	health_component.died.connect(_on_died)

func _process(_delta: float) -> void:
	var direction = _get_direction_to_player()
	velocity = direction * MAX_VELOCITY
	if velocity.is_zero_approx():
		animation_player.play("RESET")
	else:
		animation_player.play("move")

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

	move_and_slide()

func _get_direction_to_player() -> Vector2:
	if Player.instance != null:
		return (Player.instance.global_position - global_position).normalized()
	return Vector2.ZERO

func _spawn_death_particles() -> void:
	var particles: GlobGroundParticles = GLOB_GROUND_PARTICLES.instantiate()
	particles.global_position = global_position

	var background_node: Node2D = Main.instance.background_effects
	if !is_instance_valid(background_node):
		background_node = get_parent()
	background_node.add_child(particles, true)

func _on_died() -> void:
	_spawn_death_particles()
	queue_free()
