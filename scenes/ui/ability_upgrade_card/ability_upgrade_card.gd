class_name AbilityUpgradeCard
extends PanelContainer

signal selected

var ability_upgrade: AbilityUpgrade

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		audio_stream_player.play()
		selected.emit()
		Events.upgrade_selected.emit(ability_upgrade)

func set_ability_upgrade(upgrade: AbilityUpgrade) -> void:
	ability_upgrade = upgrade
	name_label.text = upgrade.name
	description_label.text = upgrade.description
