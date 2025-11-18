class_name PlayerCamera
extends Camera2D

var target_position: Vector2 = Vector2.ZERO

@onready var sky_color_sprite: Sprite2D = $SkyColorSprite

func _ready() -> void:
	sky_color_sprite.visible = true
	make_current()

func _process(delta: float) -> void:
	_update_target()
	global_position = global_position.lerp(target_position, 1 - exp(-delta * 20)).round()

func _update_target() -> void:
	if Player.instance != null:
		target_position = Player.instance.global_position
