class_name HoverAnimationComponent
extends Node

@export var amplitude: float = 1.0
@export var frequency: float = 1.0

var time_offset: float = randi()
var original_parent_position: Vector2

func _ready() -> void:
	assert(get_parent() is Node2D or get_parent() is Control, "HoverAnimationComponent requires Node2D or Control parent")
	original_parent_position = get_parent().position

func _process(delta: float) -> void:
	if get_parent() is Node2D:
		var parent: Node2D = get_parent()
		parent.position.y = original_parent_position.y + amplitude * sin(Time.get_ticks_msec() * delta * frequency + time_offset)
	if get_parent() is Control:
		var parent: Control = get_parent()
		parent.position.y = original_parent_position.y + amplitude * sin(Time.get_ticks_msec() * delta * frequency + time_offset)
