class_name LightSubViewport
extends SubViewport

const LIGHT_SPRITE = preload("uid://dcmm1luw2lklo")
const LIGHT_POOL_INITIAL_SIZE: int = 32
const LIGHT_POOL_MAX_SIZE: int = 1024

var _next_light_id: int = 0
var _light_pool: Dictionary[int, LightSprite]
var _inactive_light_pool: Dictionary[int, LightSprite]
var _active_light_pool: Dictionary[int, LightSprite]

@onready var light_container: Node2D = $LightContainer

func _ready() -> void:
	_expand_pool(LIGHT_POOL_INITIAL_SIZE)
	_ready_deferred.call_deferred()

func _ready_deferred() -> void:
	size = Main.instance.get_viewport().get_visible_rect().size
	canvas_transform = Main.instance.get_viewport().get_canvas_transform()

func _process(_delta: float) -> void:
	canvas_transform = Main.instance.get_viewport().get_canvas_transform()
	for light in _active_light_pool.values():
		var light_sprite = light as LightSprite
		light_sprite.global_position = light_sprite.light_source.global_position

func assign_light_and_get_id(light: Light, diameter: float, energy: float, hue: Color) -> int:
	var new_light_sprite_id := _get_next_light_sprite_id()
	var light_sprite: LightSprite = get_light_sprite(new_light_sprite_id)
	light_sprite.assign_light(light)
	light_sprite.set_diameter(diameter)
	light_sprite.set_energy(energy)
	light_sprite.set_hue(hue)
	return new_light_sprite_id

func release_light(light_id: int) -> void:
	_active_light_pool.erase(light_id)
	_inactive_light_pool[light_id] = get_light_sprite(light_id)

func toggle_light(light_id: int) -> void:
	var light_sprite := get_light_sprite(light_id)
	if light_sprite.visible:
		light_sprite.hide()
	else:
		light_sprite.show()

func get_light_sprite(light_id: int) -> LightSprite:
	return _light_pool[light_id]

func _get_next_light_sprite_id() -> int:
	if _inactive_light_pool.is_empty():
		_expand_pool(min(LIGHT_POOL_MAX_SIZE, _light_pool.size() * 2))
	var light_sprite_id := _inactive_light_pool.keys().back() as int
	_inactive_light_pool.erase(light_sprite_id)
	_active_light_pool[light_sprite_id] = get_light_sprite(light_sprite_id)
	return light_sprite_id

func _expand_pool(new_size: int) -> void:
	for value in range(new_size):
		var new_light_sprite: LightSprite = LIGHT_SPRITE.instantiate()
		light_container.add_child(new_light_sprite)
		_light_pool[_next_light_id] = new_light_sprite
		_inactive_light_pool[_next_light_id] = new_light_sprite
		_next_light_id += 1
