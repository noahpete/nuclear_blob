class_name DashAbilityController
extends Node

const DASH_ABILITY: PackedScene = preload("uid://c2smnlbex4blt")

@export var dash_distance: float = 8.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 1.0
@export_group("Upgrades")
@export var dash_speed_upgrade_amount: float = 0.2

var is_dashing: bool = false
var base_dash_duration: float
var dash_timer: float = 0.0
var dash_initial_speed: float = 0.0
var current_dash_ability: DashAbility = null

@onready var cooldown_timer: Timer = $CooldownTimer

func _ready() -> void:
	base_dash_duration = dash_duration
	cooldown_timer.wait_time = dash_cooldown
	cooldown_timer.one_shot = true
	Events.ability_upgrade_added.connect(_on_ability_upgrade_added)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		var player = owner if owner else get_parent().get_parent()
		if player and player.has_method("move_and_slide"):
			dash(player.velocity)

func _process(delta: float) -> void:
	if is_dashing:
		var player = owner if owner else get_parent().get_parent()
		if not player or not player.has_method("move_and_slide"):
			return

		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
			current_dash_ability = null
			return

		if current_dash_ability:
			current_dash_ability.global_position = player.global_position

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
			player.velocity += input_direction * dash_speed

		player.move_and_slide()

func dash(direction: Vector2) -> void:
	if direction.is_zero_approx():
		return
	if not cooldown_timer.is_stopped():
		return

	var player = owner if owner else get_parent().get_parent()
	if not player or not player.has_method("move_and_slide"):
		return

	dash_initial_speed = dash_distance / dash_duration
	is_dashing = true
	dash_timer = dash_duration

	cooldown_timer.start()

	player.velocity += direction.normalized() * dash_initial_speed
	$AudioStreamPlayer.play()

	current_dash_ability = DASH_ABILITY.instantiate()
	Main.instance.y_sort_root.add_child(current_dash_ability, true)
	current_dash_ability.global_position = player.global_position
	current_dash_ability.destroy_timer.start(dash_duration)

func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id == "dash_speed":
		dash_duration = base_dash_duration * pow(1 - dash_speed_upgrade_amount, current_upgrades["dash_speed"]["quantity"])
		Log.info("Upgraded Dash Speed, duration=%s" % dash_duration)
