extends Camera2D

@export var fixed_x_position: float = 580.0  # Set this value in the inspector

var y_offset: float = 0.0  # Store the vertical offset
var base_offset: float = 300.0  # The amount to move up/down

func _ready() -> void:
	# Wait 5 seconds, then move camera up
	await get_tree().create_timer(4.0).timeout
	move_camera_up()

func _process(_delta: float) -> void:
	# Get the parent's position
	var parent_position = get_parent().global_position
	
	# Set the camera's global position
	# Use the fixed X position and follow the parent's Y position plus offset
	global_position = Vector2(fixed_x_position, parent_position.y + y_offset)

func move_camera_up() -> void:
	# Create a new tween
	var tween = create_tween()
	
	# Calculate target position (move up by base_offset from current position)
	var target_offset = y_offset - base_offset
	
	# Tween the y_offset value
	tween.tween_property(
		self,  # target node
		"y_offset",  # property to animate
		target_offset,  # final value
		2.0  # duration in seconds
	).set_trans(Tween.TRANS_LINEAR)

func move_camera_down() -> void:
	# Create a new tween
	var tween = create_tween()
	
	# Calculate target position (move down by base_offset from current position)
	var target_offset = y_offset + base_offset
	
	# Tween the y_offset value
	tween.tween_property(
		self,  # target node
		"y_offset",  # property to animate
		target_offset,  # final value
		2.0  # duration in seconds
	).set_trans(Tween.TRANS_LINEAR)

func zoom_in() -> void:
	# Create a new tween
	var tween = create_tween()
	
	# Set the tween to transition the zoom property
	# from current zoom (Vector2.ONE) to 300% (Vector2(3, 3))
	# over 2 seconds with an ease in/out transition
	tween.tween_property(
		self,  # target node
		"zoom",  # property to animate
		Vector2(5, 5),  # final value
		5.0  # duration in seconds
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
