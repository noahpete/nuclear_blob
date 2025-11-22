class_name AbilityTreeNode
extends Control

@export var ability_icon: Texture2D

@onready var line_2d: Line2D = $Line2D

func _ready() -> void:
	if ability_icon == null:
		hide()
	_connect_to_parent_node()

func _connect_to_parent_node() -> void:
	if get_parent() is AbilityTreeNode:
		line_2d.add_point(global_position + size / 2)
		line_2d.add_point(get_parent().global_position + size / 2)
