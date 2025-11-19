class_name DecayManager
extends Node

signal decay_updated(current_decay: float, target_decay: float)
signal level_up(new_level: int)

const TARGET_DECAY_GROWTH_FACTOR: float = 1.2
const DECAY_RATE_FACTOR: float = 0.5

var current_decay: float = 10.0
var target_decay: float = 12.0
var current_level: int = 0
var signal_paused: bool = false

func _ready() -> void:
	decay_updated.emit(current_decay, target_decay)
	Events.glob_picked_up.connect(_on_glob_picked_up)

func _process(delta: float) -> void:
	if not signal_paused:
		current_decay = max(0, current_decay - delta * DECAY_RATE_FACTOR)
		decay_updated.emit(current_decay, target_decay)

func update_decay(amount: float) -> void:
	if not signal_paused:
		current_decay = min(current_decay + amount, target_decay)
		decay_updated.emit(current_decay, target_decay)
	if current_decay == target_decay:
		_level_up()

func _level_up() -> void:
	current_level += 1
	Log.info("Level up to level %s" % current_level)
	target_decay *= TARGET_DECAY_GROWTH_FACTOR
	level_up.emit(current_level)

	signal_paused = true
	await get_tree().create_timer(0.2).timeout
	signal_paused = false
	decay_updated.emit(current_decay, target_decay)

func _on_glob_picked_up(amount: float) -> void:
	update_decay(amount)
