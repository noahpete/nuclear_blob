class_name AbilityUpgradeCard
extends PanelContainer

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		print("Selected")
		selected.emit()

func set_ability_upgrade(upgrade: AbilityUpgrade) -> void:
	name_label.text = upgrade.name
	description_label.text = upgrade.description
