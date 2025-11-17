class_name Main
extends Node

static var instance: Main

@onready var world: Node2D = $World
@onready var y_sort_root: Node2D = $World/YSortRoot
@onready var background_effects: Node2D = $World/BackgroundEffects
@onready var light_sub_viewport: LightSubViewport = $LightSubViewport

func _ready() -> void:
	if instance != null:
		push_error("Only one instance of Main is allowed")
		return
	instance = self
