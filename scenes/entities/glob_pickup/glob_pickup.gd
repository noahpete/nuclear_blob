class_name GlobPickup
extends Sprite2D

var tween: Tween
var value: float = 8.0

@onready var area_2d: Area2D = $Area2D
@onready var light: Light = $Light

func _ready() -> void:
	var scale_tween := create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE, 0.4)\
		.from(Vector2.ZERO)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	_delayed_activate_area_2d()
	area_2d.area_entered.connect(_on_area_entered)

func _delayed_activate_area_2d() -> void:
	await get_tree().create_timer(0.8).timeout
	area_2d.monitorable = true
	area_2d.monitoring = true

func _tween_collect(percent: float, start_position: Vector2) -> void:
	if Player.instance == null:
		return
	global_position = start_position.lerp(Player.instance.global_position, percent)
	scale = Vector2.ONE.lerp(Vector2.ZERO, percent)

func _on_picked_up() -> void:
	Events.glob_picked_up.emit(value)
	var energy_tween := create_tween()
	energy_tween.tween_property(light, "energy", 0, 0.8)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	energy_tween.tween_callback(queue_free)

func _on_area_entered(_other_area: Area2D) -> void:
	if tween != null and tween.is_running():
		return
	tween = create_tween()
	tween.tween_method(_tween_collect.bind(global_position), 0.0, 1.0, 1)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN)
	tween.tween_callback(_on_picked_up)
