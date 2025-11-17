class_name Light
extends Node2D

@export_color_no_alpha var hue: Color = Color.WHITE
@export var on_by_default: bool = false
@export_range(0, 1280) var diameter: float = 1.0
@export_range(0, 1) var energy: float = 1.0

var on: bool = false
var _light_id: int = -1
var _previous_energy: float = energy

func _ready() -> void:
	_ready_deferred.call_deferred()

func _ready_deferred() -> void:
	_light_id = Main.instance.light_sub_viewport.assign_light_and_get_id(self, diameter, energy, hue)
	if on_by_default:
		turn_on()

func _process(_delta: float) -> void:
	if _previous_energy != energy:
		Main.instance.light_sub_viewport.set_light_energy(_light_id, energy)
	_previous_energy = energy

func _exit_tree() -> void:
	Main.instance.light_sub_viewport.release_light.call_deferred(_light_id)

func toggle() -> void:
	on = !on
	Main.instance.light_sub_viewport.toggle_light(_light_id)

func turn_on() -> void:
	if on:
		return
	toggle()

func turn_off() -> void:
	if !on:
		return
	toggle()

func set_hue(new_hue: Color) -> void:
	hue = new_hue
	Main.instance.light_sub_viewport.get_light_sprite(_light_id).set_hue(new_hue)

func set_diameter(new_diameter: float) -> void:
	diameter = new_diameter
	Main.instance.light_sub_viewport.get_light_sprite(_light_id).set_diameter(new_diameter)

func set_energy(new_energy: float) -> void:
	energy = new_energy
	Main.instance.light_sub_viewport.get_light_sprite(_light_id).set_energy(new_energy)
