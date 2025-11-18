class_name UpgradeManager
extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var decay_manager: DecayManager

var current_upgrades: Dictionary[String, Dictionary] = {}

func _ready() -> void:
	decay_manager.level_up.connect(_on_level_up)

func _on_level_up(current_level: int) -> void:
	var chosen_upgrade: AbilityUpgrade = upgrade_pool.pick_random()
	if chosen_upgrade == null:
		return

	var has_upgrade := current_upgrades.has(chosen_upgrade.id)
	if !has_upgrade:
		current_upgrades[chosen_upgrade.id] = {
			"resource": chosen_upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[chosen_upgrade.id]["quantity"] += 1
