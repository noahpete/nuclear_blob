class_name Liquid
extends Node2D

@export var liquid_size: Vector2 = Vector2(8, 16)
@export var surface_position_y: float = 0.5
@export_range(2, 512) var segment_count: int = 64
@export var splash_multiplier: float = 0.12
@export_range(0, 1000) var liquid_physics_speed: float = 80.0
@export var liquid_restoring_force: float = 0.02
@export var wave_energy_loss: float = 0.04
@export var wave_strength: float = 0.25
@export_range(1, 64) var wave_spread_updates: int = 8
@export var surface_line_thickness: float = 1.0
@export var surface_color: Color = Color(0.145, 0.584, 0.416, 1.0)
@export var fill_color: Color = Color(0.412, 1.0, 0.831, 1.0)

var segment_data: Array = []
var recently_splashed: bool = false
var surface_line: Line2D
var fill_polygon: Polygon2D

func _ready() -> void:
	for child in get_children():
		child.queue_free()
	_initialize_liquid()
	_bubble()

func _initialize_liquid() -> void:
	segment_data.clear()
	for i in range(segment_count):
		segment_data.append({
			"height": surface_position_y,
			"velocity": 0.0,
			"wave_to_left": 0.0,
			"wave_to_right": 0.0
		})

	var new_line := Line2D.new()
	new_line.width = surface_line_thickness
	new_line.default_color = surface_color
	add_child(new_line)
	surface_line = new_line

	var new_polygon := Polygon2D.new()
	new_polygon.color = fill_color
	new_polygon.show_behind_parent = true
	surface_line.add_child(new_polygon)
	fill_polygon = new_polygon

func _process(delta: float) -> void:
	for i in range(segment_count):
		var displacement: float = segment_data[i]["height"] - surface_position_y
		var acceleration: float = -liquid_restoring_force * displacement - segment_data[i]["velocity"] * wave_energy_loss
		segment_data[i]["velocity"] += acceleration * delta * liquid_physics_speed
		segment_data[i]["height"] += segment_data[i]["velocity"] * delta * liquid_physics_speed

	for updates in range(wave_spread_updates):
		for i in range(segment_count):
			if i > 0:
				segment_data[i]["wave_to_left"] = (segment_data[i]["height"] - segment_data[i - 1]["height"]) * wave_strength
				segment_data[i - 1]["velocity"] += segment_data[i]["wave_to_left"] * delta * liquid_physics_speed
			if i < segment_count - 1:
				segment_data[i]["wave_to_right"] = (segment_data[i]["height"] - segment_data[i + 1]["height"]) * wave_strength
				segment_data[i + 1]["velocity"] += segment_data[i]["wave_to_right"] * delta * liquid_physics_speed

		for i in range(segment_count):
			if i > 0:
				segment_data[i - 1]["height"] += segment_data[i]["wave_to_left"] * delta * liquid_physics_speed
			if i < segment_count - 1:
				segment_data[i + 1]["height"] += segment_data[i]["wave_to_right"] * delta * liquid_physics_speed

	segment_data[0]["height"] = surface_position_y
	segment_data[1]["height"] = surface_position_y
	segment_data[0]["velocity"] = 0
	segment_data[1]["velocity"] = 0

	segment_data[segment_count - 1]["height"] = surface_position_y
	segment_data[segment_count - 2]["height"] = surface_position_y
	segment_data[segment_count - 1]["velocity"] = 0
	segment_data[segment_count - 2]["velocity"] = 0

	if !recently_splashed:
		var is_still: bool = true
		for point in surface_line.points:
			if abs(abs(point.y) - abs(surface_position_y)) > 0.001:
				is_still = false
				break
		set_process(!is_still)
	else:
		recently_splashed = false

	_process_visuals()

func _process_visuals() -> void:
	var points: Array[Vector2] = []
	var segment_width: float = liquid_size.x / (segment_count - 1)
	for i in range(segment_count):
		points.append(Vector2(i * segment_width, segment_data[i]["height"]))

	var left_static_point := Vector2(points[0].x, surface_position_y)
	var right_static_point := Vector2(points[points.size() - 1].x, surface_position_y)

	var final_points: Array[Vector2] = []
	final_points.append(left_static_point)
	final_points += points
	final_points.append(right_static_point)

	surface_line.points = final_points

	var bottom_y := surface_position_y + liquid_size.y
	final_points.append(Vector2(liquid_size.x, bottom_y))
	final_points.append(Vector2(0, bottom_y))
	fill_polygon.polygon = final_points

func splash(splash_position: Vector2, splash_velocity: float) -> void:
	var local_position_x := to_local(splash_position).x
	var segment_width := liquid_size.x / (segment_count - 1)
	var index := int(clamp(local_position_x / segment_width, 0, segment_count - 1))
	segment_data[index]["velocity"] = splash_velocity
	recently_splashed = true
	set_process(true)

func _bubble() -> void:
	splash(global_position + Vector2(liquid_size.x * randf(), 0), randi_range(4, 8))
	await get_tree().create_timer(0.1).timeout
	_bubble()
