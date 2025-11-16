class_name HurtboxComponent
extends Area2D

signal hit

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(other_area: Area2D) -> void:
	if not other_area is HitboxComponent:
		return
	hit.emit()
