class_name ShootAbilityController
extends Node

const GLOB_PROJECTILE = preload("uid://buyg2u6ftbuc4")

var base_damage: int = 2
var base_fire_rate_time: float = 0.5
var base_velocity: int = 150
var additional_damage_percent: float = 1.0
var additional_fire_rate_percent: float = 1.0
var additional_velocity_percent: float = 1.0

@onready var fire_rate_timer: Timer = $FireRateTimer

func _ready() -> void:
	Events.ability_upgrade_added.connect(_on_ability_upgrade_added)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		shoot(owner.global_position.direction_to(owner.get_global_mouse_position()))

func shoot(direction: Vector2) -> void:
	if !fire_rate_timer.is_stopped():
		return
	var glob_projectile: GlobProjectile = GLOB_PROJECTILE.instantiate()
	Main.instance.y_sort_root.add_child(glob_projectile, true)
	glob_projectile.global_position = owner.global_position
	glob_projectile.initialize(direction)
	glob_projectile.hitbox_component.damage = base_damage * additional_damage_percent
	glob_projectile.velocity = base_velocity * additional_velocity_percent
	fire_rate_timer.start(base_fire_rate_time * additional_fire_rate_percent)

func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade is Ability:
		return
	match upgrade.id:
		"shoot_damage":
			additional_damage_percent += 0.15
		"shoot_rate":
			additional_fire_rate_percent *= 0.9
		"shoot_velocity":
			additional_velocity_percent *= 1.1
	Log.info("ShootAbility: damage=%s, rate=%s, velocity=%s" % [base_damage * additional_damage_percent,
		base_fire_rate_time * additional_fire_rate_percent, base_velocity * additional_velocity_percent])
