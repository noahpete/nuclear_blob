@tool
class_name AbilityTreeNode
extends Node2D

@export var ability_icon: Texture2D

@onready var line_2d: Line2D = $Line2D
@onready var glob_sprite_2d: Sprite2D = %GlobSprite2D
@onready var icon_sprite_2d: Sprite2D = %IconSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if ability_icon == null or not (get_parent() is AbilityTreeNode):
		glob_sprite_2d.hide()
	else:
		icon_sprite_2d.texture = ability_icon
	_connect_to_parent_node()

	# Randomize animation start time to desynchronize instances
	if animation_player and animation_player.has_animation("default"):
		animation_player.play("default")
		animation_player.seek(randf() * animation_player.current_animation_length, true)

func _connect_to_parent_node() -> void:
	if get_parent() is AbilityTreeNode:
		line_2d.add_point(global_position)
		line_2d.add_point(get_parent().global_position)
