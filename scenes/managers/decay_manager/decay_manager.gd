class_name DecayManager
extends Node

signal decay_updated(current_decay: float, target_decay: float)

const TARGET_DECAY_GROWTH_FACTOR: float = 1.5
const DECAY_DECAY_GROWTH_FACTOR: float = TARGET_DECAY_GROWTH_FACTOR + 0.1

static var instance: DecayManager

var current_decay: float = 10.0
var target_decay: float = 12.0
var decay_rate_factor: float = 0.9
var current_level: int = 8
var paused: bool = false

func _ready() -> void:
	if instance:
		push_error("Cannot have multiple instances of DecayManager")
		return
	instance = self
	decay_updated.emit(current_decay, target_decay)
	Events.level_up.emit(current_level)
	Events.glob_picked_up.connect(_on_glob_picked_up)

func _process(delta: float) -> void:
	if not paused:
		current_decay = max(0, current_decay - delta * decay_rate_factor)
		decay_updated.emit(current_decay, target_decay)
		if current_decay <= 0.1:
			Events.player_died.emit(current_level)
			paused = true

func update_decay(amount: float) -> void:
	if not paused:
		current_decay = min(current_decay + amount, target_decay)
		decay_updated.emit(current_decay, target_decay)
	if current_decay >= target_decay:
		_level_up()

func _level_up() -> void:
	current_level += 1
	Log.info("Level up to level %s" % current_level)
	target_decay *= TARGET_DECAY_GROWTH_FACTOR
	decay_rate_factor *= DECAY_DECAY_GROWTH_FACTOR
	Events.level_up.emit(current_level)

	paused = true
	await get_tree().create_timer(3).timeout
	paused = false
	decay_updated.emit(current_decay, target_decay)

func _on_glob_picked_up(amount: float) -> void:
	update_decay(amount)
