extends Node

# Round stats
var round_level_reached: int
var round_kills: int
var round_time_msec: int

# Player data
var player_data: PlayerData = preload("uid://cdptgs84vgor3")

func _ready() -> void:
	Events.post_round_ability_purchased.connect(_on_ability_purchased)

func _on_ability_purchased(ability: Ability) -> void:
	player_data.current_xp -= ability.cost
	player_data.abilities.append(ability)
