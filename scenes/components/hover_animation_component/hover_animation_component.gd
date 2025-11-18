class_name HoverAnimationComponent
extends Node

@export var amplitude: float = 1.0
@export var frequency: float = 1.0

var time_offset: float = randi()

func _ready() -> void:
	assert(get_parent() is Node2D, "HoverAnimationComponent requires Node2D parent")

func _process(delta: float) -> void:
	var parent: Node2D = get_parent()
	parent.position.y += amplitude * sin(Time.get_ticks_msec() * delta * frequency + time_offset)
