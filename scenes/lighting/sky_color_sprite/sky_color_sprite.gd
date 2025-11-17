class_name SkyColorSprite
extends Sprite2D

@export var camera: Camera2D

func _ready() -> void:
	_ready_deferred.call_deferred()

func _ready_deferred() -> void:
	texture = Main.instance.light_sub_viewport.get_texture()

func _process(delta: float) -> void:
	if camera:
		global_position = camera.get_screen_center_position()
