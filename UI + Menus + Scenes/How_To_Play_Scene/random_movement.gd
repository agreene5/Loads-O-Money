extends Sprite2D

# Variables for setting the movement and rotation bounds
var base_position: Vector2
var move_bounds: float = 30.0

# Variables for controlling movement and rotation speed
var move_duration: float = 1.5  # Time it takes to move to a new position
var stop_duration: float = 0.5  # Time it stays idle before moving again
var rotation_speed: float = 2.0  # Speed of rotation

# State tracking
var target_position: Vector2
var target_rotation: float
var elapsed_time: float = 0.0

func _ready():
	# Store the starting position as the base position
	base_position = position
	# Pick an initial random target position and rotation
	_set_random_target()

	# Start the process loop
	set_process(true)

func _process(delta: float):
	# Move and rotate towards the target
	if elapsed_time < move_duration:
		# Interpolate position towards the target position
		position = position.lerp(target_position, delta / (move_duration - elapsed_time))
		
		# Interpolate rotation towards the target rotation using the global lerp_angle function
		rotation = lerp_angle(rotation, target_rotation, delta * rotation_speed)
		
		elapsed_time += delta
	else:
		# If the movement is done, wait for stop_duration before choosing a new target
		elapsed_time += delta
		if elapsed_time >= move_duration + stop_duration:
			_set_random_target()

func _set_random_target():
	# Pick a new random position within the bounds (30 units from the base position)
	var random_offset = Vector2(
		randf_range(-move_bounds, move_bounds),
		randf_range(-move_bounds, move_bounds)
	)
	target_position = base_position + random_offset

	# Pick a new random rotation in radians (full circle)
	target_rotation = randf_range(0, TAU)

	# Reset elapsed time to start movement
	elapsed_time = 0.0
