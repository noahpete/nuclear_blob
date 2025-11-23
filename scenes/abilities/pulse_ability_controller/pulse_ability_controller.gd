class_name PulseAbilityController
extends Node

const PULSE_ABILITY: PackedScene = preload("uid://dahadadkurskm")

var cooldown_base: float = 8.0
var cooldown_multiplier: float = 1.0
var damage_base: float = 3.0
var damage_multiplier: float = 1.0
var knockback_base: float = 200.0
var knockback_multiplier: float = 1.0

@onready var cooldown_timer: Timer = $CooldownTimer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pulse"):
		pulse()

func pulse() -> void:
	if !cooldown_timer.is_stopped():
		return
	var pulse_ability: PulseAbility = PULSE_ABILITY.instantiate()
	Main.instance.y_sort_root.add_child(pulse_ability)
	pulse_ability.global_position = owner.global_position
	pulse_ability.hitbox_component.damage = damage_base * damage_multiplier
	pulse_ability.knockback_amount = knockback_base * knockback_multiplier
	cooldown_timer.start(cooldown_base * cooldown_multiplier)

func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade is Ability:
		return
	match upgrade.id:
		"pulse_cooldown":
			cooldown_multiplier *= 0.85
		"pulse_damage":
			damage_multiplier *= 1.1
		"shoot_velocity":
			knockback_multiplier *= 1.15
	Log.info("PulseAbility: damage=%s, cooldown=%s, knockback=%s" % [damage_base * damage_multiplier,
		cooldown_base * cooldown_multiplier, knockback_base * knockback_multiplier])
