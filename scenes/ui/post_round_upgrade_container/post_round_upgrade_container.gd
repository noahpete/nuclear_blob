class_name PostRoundUpgradeContainer
extends PanelContainer

var current_ability: Ability

@onready var select_an_ability_label: Label = %SelectAnAbilityLabel
@onready var v_box_container: VBoxContainer = %VBoxContainer
@onready var ability_label: Label = %AbilityLabel
@onready var ability_icon_texture_rect: TextureRect = %AbilityIconTextureRect
@onready var ability_rich_text_label: RichTextLabel = %AbilityRichTextLabel
@onready var buy_button: Button = %BuyButton

func _ready() -> void:
	GlobalAudio.register_buttons([buy_button])
	Events.post_round_ability_selected.connect(_on_post_round_ability_selected)
	buy_button.pressed.connect(_on_post_round_ability_buy_button_pressed)

func _on_post_round_ability_selected(ability: Ability) -> void:
	select_an_ability_label.visible = false
	v_box_container.visible = true

	current_ability = ability
	ability_label.text = ability.name
	ability_icon_texture_rect.texture = ability.ability_icon_texture
	ability_rich_text_label.text = ability.description
	buy_button.text = "Buy for %d" % ability.cost

	var ability_already_acquired := false
	for a in GameState.player_data.abilities:
		if a.id == ability.id:
			ability_already_acquired = true
			break
	buy_button.disabled = (GameState.player_data.current_xp < ability.cost) or ability_already_acquired

func _on_post_round_ability_buy_button_pressed() -> void:
	select_an_ability_label.visible = true
	v_box_container.visible = false
	Events.post_round_ability_purchased.emit(current_ability)
