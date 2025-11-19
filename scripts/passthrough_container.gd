@tool
class_name PassthroughControl
extends Container

@export var center_pivot_offset: bool = false:
	set(value):
		center_pivot_offset = value
		queue_sort()

func _ready() -> void:
	sort_children.connect(_on_sort_children)

func _get_configuration_warnings() -> PackedStringArray:
	var control_children = 0
	for child in get_children():
		if child is Control:
			control_children += 1

	if control_children > 1:
		return PackedStringArray(["PassthroughControl only works with a single Control child!"])
	return PackedStringArray()

func _get_first_child_control() -> Control:
	for child in get_children():
		if child is Control:
			return child
	Log.info("No child found, returning null")
	return null

func _do_sort() -> void:
	# target root of passthrough chain
	if get_parent() is PassthroughControl:
		var passthrough_control_root = get_parent() as PassthroughControl
		passthrough_control_root._do_sort()
		return

	# find deepest nested non-passthrough control node
	var root_child: Control = _get_first_child_control()

	var passthrough_list: Array[PassthroughControl] = []
	while root_child is PassthroughControl:
		var passthrough_control = root_child as PassthroughControl
		passthrough_list.append(passthrough_control)
		root_child = passthrough_control._get_first_child_control()

	if root_child != null:
		size_flags_horizontal = root_child.size_flags_horizontal
		size_flags_vertical = root_child.size_flags_vertical

		root_child.size = Vector2.ZERO
		# set minimum size, for shrink-related size flags
		custom_minimum_size = root_child.get_combined_minimum_size()
		# set root child size to the root passthrough size, for fill-related flags
		root_child.size = size

		if center_pivot_offset:
			root_child.pivot_offset = root_child.size / 2.0
		else:
			root_child.pivot_offset = Vector2.ZERO

		if !root_child.get_children().is_empty():
			root_child.get_child(0).pivot_offset = root_child.get_child(0).size / 2

		pivot_offset = root_child.pivot_offset

		if Engine.is_editor_hint():
			root_child.position = Vector2.ZERO

	# ensure every passthrough item matches size and flags
	for pt in passthrough_list:
		pt.center_pivot_offset = center_pivot_offset
		pt.size_flags_horizontal = size_flags_horizontal
		pt.size_flags_vertical = size_flags_vertical
		pt.custom_minimum_size = custom_minimum_size
		pt.size = size
		pt.pivot_offset = pivot_offset

func _on_sort_children() -> void:
	_do_sort()
