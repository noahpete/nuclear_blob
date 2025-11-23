class_name SprayAbilityController
extends Node

const SPRAY_ABILITY = preload("uid://8wnos6mmpvbj")

var cooldown_base: float = 5.0
var cooldown_multiplier: float = 1.0
var damage_base: float = 4.0
var damage_multiplier: float = 1.0

@onready var cooldown_timer: Timer = $CooldownTimer

func _ready() -> void:
	Events.ability_upgrade_added.connect(_on_ability_upgrade_added)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spray"):
		spray()

func spray() -> void:
	if !cooldown_timer.is_stopped():
		return

	var player = owner if owner else get_parent().get_parent()
	if not player:
		return

	var spray_instance: SprayAbility = SPRAY_ABILITY.instantiate()
	Main.instance.y_sort_root.add_child(spray_instance)
	spray_instance.global_position = player.global_position
	spray_instance.look_at(player.get_global_mouse_position())
	spray_instance.hitbox_component.damage = damage_base * damage_multiplier
	cooldown_timer.start(cooldown_base * cooldown_multiplier)

func _on_ability_upgrade_added(upgrade: AbilityUpgrade, _current_upgrades: Dictionary) -> void:
	if upgrade is Ability:
		return
	if upgrade.id == "spray_damage":
		damage_multiplier *= 1.15
	elif upgrade.id == "spray_cooldown":
		cooldown_multiplier *= 0.85
