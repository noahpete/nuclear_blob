class_name Rat
extends CharacterBody2D

@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var visuals: Node2D = $Visuals

func _ready() -> void:
	hurtbox_component.hit.connect(_on_hit)

func _on_hit() -> void:
	for child in visuals.get_children():
		if child is FlashSpriteComponent:
			var flash_sprite: FlashSpriteComponent = child
			flash_sprite.flash()
