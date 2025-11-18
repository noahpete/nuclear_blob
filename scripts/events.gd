extends Node

signal glob_picked_up(amount: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)

func emit_glob_picked_up(amount: float) -> void:
	glob_picked_up.emit(amount)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	ability_upgrade_added.emit(upgrade, current_upgrades)
