class_name UpgradeScreen
extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

const ABILITY_UPGRADE_CARD = preload("uid://c614tbkbl88uu")

@onready var card_container: HBoxContainer = $MarginContainer/CardContainer

func _ready() -> void:
	pass
	#get_tree().paused = true

func set_ability_upgrades(upgrades: Array[AbilityUpgrade]) -> void:
	for upgrade in upgrades:
		var card: AbilityUpgradeCard = ABILITY_UPGRADE_CARD.instantiate()
		card_container.add_child(card)
		card.set_ability_upgrade(upgrade)
		card.selected.connect(_on_upgrade_selected.bind(upgrade))

func _on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	upgrade_selected.emit(upgrade)
	get_tree().paused = false
	queue_free()
