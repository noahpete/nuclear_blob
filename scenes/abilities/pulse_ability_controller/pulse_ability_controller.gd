class_name PulseAbilityController
extends Node

const PULSE_ABILITY: PackedScene = preload("uid://dahadadkurskm")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pulse"):
		pulse()

func pulse() -> void:
	var pulse_ability: PulseAbility = PULSE_ABILITY.instantiate()
	Main.instance.y_sort_root.add_child(pulse_ability)
	pulse_ability.global_position = owner.global_position
