class_name DashAbilityController
extends Node

const DASH_ABILITY = preload("uid://c2smnlbex4blt")

@export var parent: CharacterBody2D
@export var dash_distance: float = 200.0
@export var dash_duration: float = 0.4

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_initial_speed: float = 0.0
var current_dash_ability: DashAbility = null

func _process(delta: float) -> void:
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
			current_dash_ability = null
			return

		# Update dash ability position to follow parent
		if current_dash_ability:
			current_dash_ability.global_position = parent.global_position

		# Get current input for steering
		var input_direction := Input.get_vector("left", "right", "up", "down")
		if input_direction.length() > 0:
			input_direction = input_direction.normalized()

		# Calculate progress and apply cubic ease-out
		var progress: float = 1.0 - (dash_timer / dash_duration)
		var t: float = 1.0 - progress
		var speed_multiplier: float = t * t * t

		# Calculate velocity (allow steering if there's input, otherwise use stored direction)
		var dash_speed := dash_initial_speed * speed_multiplier
		if not input_direction.is_zero_approx():
			parent.velocity = input_direction * dash_speed

		parent.move_and_slide()

func dash(direction: Vector2) -> void:
	if parent == null:
		push_error("DashAbilityController has no parent")
	if direction.is_zero_approx():
		return

	# Calculate initial speed based on distance and duration
	dash_initial_speed = dash_distance / dash_duration
	is_dashing = true
	dash_timer = dash_duration

	parent.velocity = direction.normalized() * dash_initial_speed

	current_dash_ability = DASH_ABILITY.instantiate()
	Main.instance.y_sort_origin.add_child(current_dash_ability, true)
	current_dash_ability.global_position = parent.global_position
	current_dash_ability.destroy_timer.start(dash_duration * 0.8)
