class_name UpgradeManager
extends Node

const UPGRADE_SCREEN = preload("uid://m8mtvpnedqvk")

@export var upgrade_pool: Array[AbilityUpgrade]
@export var interactable_ui: CanvasLayer

var current_upgrades: Dictionary[String, Dictionary] = {}

func _ready() -> void:
	Events.level_up.connect(_on_level_up)

func _on_level_up(_current_level: int) -> void:
	var chosen_upgrade: AbilityUpgrade = upgrade_pool.pick_random()
	if chosen_upgrade == null:
		return

	var upgrade_screen: UpgradeScreen = UPGRADE_SCREEN.instantiate()
	add_child(upgrade_screen)
	upgrade_screen.set_ability_upgrades([chosen_upgrade])
	upgrade_screen.upgrade_selected.connect(_on_upgrade_selected)

func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var has_upgrade := current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1

	Events.ability_upgrade_added.emit(upgrade, current_upgrades)

func _on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)
