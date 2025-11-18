class_name GlobPickup
extends Sprite2D

@onready var area_2d: Area2D = $Area2D
@onready var light: Light = $Light

func _ready() -> void:
	var scale_tween := create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE, 0.4)\
		.from(Vector2.ZERO)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	area_2d.area_entered.connect(_on_area_entered)
	_delayed_activate_area_2d()

func _delayed_activate_area_2d() -> void:
	await get_tree().create_timer(0.8).timeout
	area_2d.monitorable = true
	area_2d.monitoring = true

func _on_area_entered(other_area: Area2D) -> void:
	Events.glob_picked_up.emit(1)
	var energy_tween := create_tween()
	energy_tween.tween_property(light, "energy", 0, 0.8)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	energy_tween.tween_callback(queue_free)
