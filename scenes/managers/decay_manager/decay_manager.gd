class_name DecayManager
extends Node

signal decay_updated(current_decay: float, target_decay: float)

const TARGET_DECAY_GROWTH_FACTOR: float = 1.6

var current_decay: float = 10.0
var target_decay: float = 15.0
var current_level: int = 0

func _ready() -> void:
	Events.glob_picked_up.connect(_on_glob_picked_up)

func _process(delta: float) -> void:
	current_decay = max(0, current_decay - delta)
	decay_updated.emit(current_decay, target_decay)

func update_decay(amount: float) -> void:
	current_decay = min(current_decay + amount, target_decay)
	decay_updated.emit(current_decay, target_decay)
	if current_decay == target_decay:
		current_decay += 1
		target_decay *= TARGET_DECAY_GROWTH_FACTOR
		decay_updated.emit(current_decay, target_decay)

func _on_glob_picked_up(amount: float) -> void:
	Log.info("Changing Decay %s -> %s" % [str(current_decay), str(current_decay + amount)])
	update_decay(amount)
