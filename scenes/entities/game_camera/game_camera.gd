class_name GameCamera
extends Camera2D

@export var noise_texture: FastNoiseLite

var target_position: Vector2 = Vector2.ZERO

@onready var sky_light_sprite: Sprite2D = $SkyLightSprite
@onready var shake_animation_component: ShakeAnimationComponent = $ShakeAnimationComponent

func _ready() -> void:
	make_current()

func _process(delta: float) -> void:
	_update_target()
	sky_light_sprite.offset = offset
	global_position = global_position.lerp(target_position, 1 - exp(-delta * 20)).round()

func _update_target() -> void:
	if Player.instance != null:
		target_position = Player.instance.global_position
