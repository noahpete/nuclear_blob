class_name LightSprite
extends Sprite2D

var light_source: Light = null

func _ready() -> void:
	hide()

func assign_light(light: Light) -> void:
	light_source = light

func release_light() -> void:
	light_source = null
	hide()

func set_diameter(diameter: float) -> void:
	scale = Vector2.ONE * diameter

func set_energy(energy: float) -> void:
	modulate.a = energy

func set_hue(hue: Color) -> void:
	modulate.r = hue.r
	modulate.g = hue.g
	modulate.b = hue.b
