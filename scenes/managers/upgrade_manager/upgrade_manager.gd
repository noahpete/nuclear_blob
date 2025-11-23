class_name UpgradeManager
extends Node

const UPGRADE_SCREEN = preload("uid://m8mtvpnedqvk")

@export var starting_upgrade_pool: Array[AbilityUpgrade]
@export var dash_upgrade_pool: Array[AbilityUpgrade]
@export var interactable_ui: CanvasLayer

var upgrade_pool: Array[AbilityUpgrade]
var current_upgrades: Dictionary[String, Dictionary] = {}

func _ready() -> void:
	Events.level_up.connect(_on_level_up)
	upgrade_pool = starting_upgrade_pool.duplicate()

func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var has_upgrade := current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1

	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool = upgrade_pool.filter(func(pool_upgrade):
				return pool_upgrade.id != upgrade.id
			)

	Events.ability_upgrade_added.emit(upgrade, current_upgrades)

func _pick_upgrades() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades = upgrade_pool.duplicate()
	for i in range(3):
		var chosen_upgrade: AbilityUpgrade = filtered_upgrades.pick_random()
		if chosen_upgrade == null:
			break
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter(func(upgrade):
			return upgrade.id != chosen_upgrade.id
		)
	return chosen_upgrades

func _try_add_upgrade_to_pool(new_upgrade_pool: Array[AbilityUpgrade]) -> void:
	if new_upgrade_pool.size() == 0 or new_upgrade_pool[0] in upgrade_pool:
		return
	upgrade_pool += new_upgrade_pool
	Log.info("Added upgrade pool (example upgrade: %s)" % new_upgrade_pool[0])

func _on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)

func _on_level_up(_current_level: int) -> void:
	var upgrade_screen: UpgradeScreen = UPGRADE_SCREEN.instantiate()
	add_child(upgrade_screen)
	var chosen_upgrades := _pick_upgrades()
	upgrade_screen.set_ability_upgrades(chosen_upgrades)
	upgrade_screen.upgrade_selected.connect(_on_upgrade_selected)

func _on_ability_upgrade_unlock(ability_upgrade: AbilityUpgrade) -> void:
	if not ability_upgrade is Ability:
		return
	match ability_upgrade.parent_ability_id:
		"dash":
			_try_add_upgrade_to_pool(dash_upgrade_pool)
