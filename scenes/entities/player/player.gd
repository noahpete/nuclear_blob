class_name Player
extends CharacterBody2D

const GLOB = preload("uid://buyg2u6ftbuc4")
const MAX_VELOCITY: float = 120.0
const ACCELERATION_SMOOTHING: float = 15.0

static var instance: Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: CanvasGroup = $Visuals
@onready var body_globs: GPUParticles2D = $Visuals/BodyGlobs
@onready var eyes_sprite_2d: Sprite2D = $Visuals/EyesSprite2D
@onready var shoot_ability_controller: ShootAbilityController = $Abilities/ShootAbilityController
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var abilities: Node = %Abilities

func _ready() -> void:
	if instance:
		push_error("Only one Player can exist!")
	instance = self
	Events.ability_upgrade_added.connect(_on_ability_upgrade_added)
	hurtbox_component.hit.connect(_on_hurtbox_hit)

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("left", "right", "up", "down")

	if input_vector.is_zero_approx():
		animation_player.play("RESET")
	else:
		animation_player.play("move")

	_update_skew(delta)
	_update_eyes(delta)
	_update_globs(delta)

	velocity = velocity.lerp(input_vector * MAX_VELOCITY, 1 - exp(-ACCELERATION_SMOOTHING * delta))
	move_and_slide()
	position = position.round()

func _update_skew(delta: float) -> void:
	var target_skew := deg_to_rad(Input.get_axis("left", "right") * 5)
	visuals.skew = lerp(visuals.skew, target_skew, delta * 10)

func _update_globs(delta: float) -> void:
	var target_position := -1 * Input.get_vector("left", "right", "up", "down") * 2
	body_globs.position = lerp(body_globs.position, target_position, delta * 10)

func _update_eyes(delta: float) -> void:
	var target_position := Input.get_vector("left", "right", "up", "down") * 2
	eyes_sprite_2d.position = lerp(eyes_sprite_2d.position, target_position, delta * 10)

func _on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if ability_upgrade is Ability:
		abilities.add_child(ability_upgrade.ability_controller_scene.instantiate())

func _on_hurtbox_hit(hitbox_component: HitboxComponent) -> void:
	DecayManager.instance.update_decay(-DecayManager.instance.target_decay * 0.1)
