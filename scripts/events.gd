extends Node

signal player_died(level: int)
signal level_up(new_level: int)
signal glob_picked_up(amount: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)

# UI
signal ability_selected(ability: Ability)

func emit_player_died() -> void:
	player_died.emit()

func emit_level_up(new_level: int) -> void:
	level_up.emit(new_level)

func emit_glob_picked_up(amount: float) -> void:
	glob_picked_up.emit(amount)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	ability_upgrade_added.emit(upgrade, current_upgrades)

func emit_ability_selected(ability: Ability) -> void:
	ability_selected.emit(ability)
