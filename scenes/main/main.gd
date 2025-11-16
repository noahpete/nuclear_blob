class_name Main
extends Node

static var instance: Main

@onready var world: Node2D = $World
@onready var y_sort_origin: Node2D = $World/YSortOrigin

func _ready() -> void:
	if instance != null:
		push_error("Only one instance of Main is allowed")
	instance = self
