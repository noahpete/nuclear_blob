@tool
class_name AbilityTreeNode
extends Node2D

static var currently_selected_node: AbilityTreeNode = null

@export var ability: Ability
@export var ability_icon: Texture2D

@onready var line_2d: Line2D = $Line2D
@onready var glob_sprite_2d: Sprite2D = %GlobSprite2D
@onready var icon_sprite_2d: Sprite2D = %IconSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D
@onready var outline_sprite_2d: Sprite2D = $OutlineSprite2D

var selected: bool
var glob_gradient: Gradient
var outline_gradient: Gradient

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
#
	var glob_gradient_texture: GradientTexture2D = glob_sprite_2d.texture
	glob_gradient_texture = glob_gradient_texture.duplicate()
	glob_sprite_2d.texture = glob_gradient_texture
	glob_gradient = glob_gradient_texture.gradient.duplicate()
	glob_sprite_2d.texture.gradient = glob_gradient

	# Make gradient unique for this instance and set initial transparency
	var gradient_texture: GradientTexture2D = outline_sprite_2d.texture as GradientTexture2D
	gradient_texture = gradient_texture.duplicate()
	outline_sprite_2d.texture = gradient_texture
	outline_gradient = gradient_texture.gradient.duplicate()
	gradient_texture.gradient = outline_gradient
	outline_gradient.colors[1].a = 0.0

	area_2d.mouse_entered.connect(_on_mouse_entered)
	area_2d.mouse_exited.connect(_on_mouse_exited)
	area_2d.input_event.connect(_on_area_2d_input_event)

func unlock() -> void:
	var start_color := glob_gradient.colors[0]
	var target_color := Color(0.412, 1.0, 0.831, 1.0)
	var tween := create_tween()
	tween.tween_method(func(color: Color): glob_gradient.set_color(0, color), start_color, target_color, 0.4)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

func _connect_to_parent_node() -> void:
	if get_parent() is AbilityTreeNode:
		line_2d.add_point(global_position)
		line_2d.add_point(get_parent().global_position)

func _on_mouse_entered() -> void:
	var tween := create_tween()
	var start_color := outline_gradient.colors[1]
	var target_color := Color(start_color.r, start_color.g, start_color.b, 1.0)
	tween.tween_method(func(color: Color): outline_gradient.set_color(1, color), start_color, target_color, 0.2)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

func _on_mouse_exited() -> void:
	if selected:
		return
	var tween := create_tween()
	var start_color := outline_gradient.colors[1]
	var target_color := Color(start_color.r, start_color.g, start_color.b, 0.0)
	tween.tween_method(func(color: Color): outline_gradient.set_color(1, color), start_color, target_color, 0.2)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

func select() -> void:
	if currently_selected_node != null and currently_selected_node != self:
		currently_selected_node.deselect()

	selected = true
	currently_selected_node = self
	Events.post_round_ability_selected.emit(ability)

func deselect() -> void:
	selected = false
	# Fade out outline if mouse is not hovering
	if not area_2d.has_overlapping_areas():
		var tween := create_tween()
		var start_color := outline_gradient.colors[1]
		var target_color := Color(start_color.r, start_color.g, start_color.b, 0.0)
		tween.tween_method(func(color: Color): outline_gradient.set_color(1, color), start_color, target_color, 0.2)\
			.set_trans(Tween.TRANS_CUBIC)\
			.set_ease(Tween.EASE_OUT)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Log.info("Selected Ability with id %s" % [ability.parent_ability_id])
		select()
