extends RigidBody2D

@export var Speed: float = 500
@export var Position_Smoothing: float = 10.0
@export var Rotation_Speed: float = 5.0

var current_path_offset: float = 0.0
var path: Line2D
var path_length: float = 0.0
var target_position: Vector2 = Vector2.ZERO
var next_point_index: int = 1

var is_replaying = false
var recording_enabled = true
var replay_mode = false
var current_replay_index = 0

# Position storage
var stored_position: Vector2
var stored_rotation: float

@onready var car_collision_shape = $Car_Death_Box/CollisionShape2D

var MLG_video = preload("res://UI + Menus + Scenes/MLG_Scene/MLG_Instant_Replay_Video.tscn")
var MLG_video_instance = MLG_video.instantiate()

# Class to store the movement data
class PositionState:
	var timestamp: float
	var position: Vector2
	var rotation: float

	func _init(ts, pos, rot):
		timestamp = ts
		position = pos
		rotation = rot

func _ready():
	gravity_scale = 0
	linear_damp = Position_Smoothing
	_initialize_path()

func _initialize_path():
	await get_tree().process_frame
	path = get_tree().root.find_child("Default_Enemy_Path", true, false)
	if path:
		path_length = calculate_path_length()
		current_path_offset = get_nearest_offset()
		target_position = get_point_on_path(current_path_offset)
		position = target_position
		update_next_point_index()
	else:
		push_error("Default_Enemy_Path not found!")

func _process(delta):
	if replay_mode:
		process_replay(delta)
	else:
		store_position(delta)

func store_position(delta):
	if not recording_enabled or replay_mode:
		return

	var current_time = Time.get_ticks_msec() / 1000.0
	var position_state = PositionState.new(current_time, global_position, rotation)

	Global_Variables.Car_Stored_Positions.append(position_state)

	# Remove old positions older than 5 seconds
	while Global_Variables.Car_Stored_Positions.size() > 0:
		var oldest_state = Global_Variables.Car_Stored_Positions[0]
		if current_time - oldest_state.timestamp > 5.0:
			Global_Variables.Car_Stored_Positions.pop_front()
		else:
			break

func process_replay(delta):
	if current_replay_index >= Global_Variables.Car_Stored_Positions.size():
		end_replay()
		return

	var position_state = Global_Variables.Car_Stored_Positions[current_replay_index]
	
	# Set position and rotation during replay
	global_position = position_state.position
	rotation = position_state.rotation

	current_replay_index += 1

func start_replay():
	if Global_Variables.Car_Stored_Positions.size() > 0:
		#Add MLG video
		add_child(MLG_video_instance)
	
		is_replaying = true
		stored_position = global_position
		stored_rotation = rotation

		# Get the oldest recorded state
		var oldest_state = Global_Variables.Car_Stored_Positions[0]

		# Set initial replay position
		global_position = oldest_state.position
		rotation = oldest_state.rotation

		# Start replay
		replay_mode = true
		recording_enabled = false
		current_replay_index = 0
		

func end_replay():
	#Remove MLG Video
	remove_child(MLG_video_instance)
	MLG_video_instance.queue_free()
	
	is_replaying = false
	rotation = stored_rotation  # Keep this to restore the original rotation

	replay_mode = false
	recording_enabled = true
	current_replay_index = 0

	# Find the nearest point on the path to the current position
	current_path_offset = get_nearest_offset()
	target_position = get_point_on_path(current_path_offset)
	update_next_point_index()

func calculate_path_length() -> float:
	var length = 0.0
	for i in range(1, path.points.size()):
		length += path.points[i].distance_to(path.points[i-1])
	return length

func get_nearest_offset() -> float:
	var nearest_offset = 0.0
	var nearest_distance = INF
	var current_offset = 0.0

	for i in range(path.points.size() - 1):
		var segment_start = path.to_global(path.points[i])
		var segment_end = path.to_global(path.points[i + 1])
		var segment_length = segment_start.distance_to(segment_end)

		var closest_point = Geometry2D.get_closest_point_to_segment(global_position, segment_start, segment_end)
		var distance = global_position.distance_to(closest_point)

		if distance < nearest_distance:
			nearest_distance = distance
			nearest_offset = current_offset + segment_start.distance_to(closest_point)

		current_offset += segment_length

	return nearest_offset

func _integrate_forces(state):
	if not path:
		return

	follow_path(state)

func follow_path(state):
	var next_position = get_point_on_path(current_path_offset + Speed * state.step)
	target_position = get_point_on_path(current_path_offset)

	state.transform.origin = state.transform.origin.lerp(target_position, Position_Smoothing * state.step)

	# Apply a force in the direction of movement
	var force_direction = (next_position - state.transform.origin).normalized()
	state.apply_central_force(force_direction * Speed)

	# Rotate towards the next point
	var next_point = path.to_global(path.points[next_point_index])
	var direction_to_next = (next_point - global_position).normalized()
	var angle_to_next = transform.x.angle_to(direction_to_next)

	angle_to_next -= PI/2

	state.angular_velocity = angle_to_next * Rotation_Speed

	current_path_offset += Speed * state.step
	if current_path_offset >= path_length:
		current_path_offset = 0
		next_point_index = 1
	else:
		update_next_point_index()

func get_point_on_path(offset: float) -> Vector2:
	var current_distance = 0.0
	for i in range(1, path.points.size()):
		var segment_length = path.points[i].distance_to(path.points[i-1])
		if current_distance + segment_length > offset:
			var t = (offset - current_distance) / segment_length
			return path.to_global(path.points[i-1].lerp(path.points[i], t))
		current_distance += segment_length
	return path.to_global(path.points[-1])

func update_next_point_index():
	var current_distance = 0.0
	for i in range(1, path.points.size()):
		var segment_length = path.points[i].distance_to(path.points[i-1])
		if current_distance + segment_length > current_path_offset:
			next_point_index = i
			return
		current_distance += segment_length
	next_point_index = 0

	
	
