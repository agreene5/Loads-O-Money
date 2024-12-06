# This script determines enemy movement, they move towards the player and aim to keep a 200
# unit distance, but they're rigid bodies so it's not 100% clean for them to do so.
# Also, if the tax enemy gets stuck in place for 5 seconds or more it gets teleported
# to the nearest point on a line that stretches across most of the map

extends RigidBody2D

enum State {FOLLOW_PATH, CHASE_PLAYER, RETURN_TO_PATH}

@export var Speed: float = 400
@export var Chase_Distance: float = 1000
@export var Upright_Force: float = 5.0
@export var Path_Follow_Distance: float = 10.0

var current_path_offset: float = 0.0
var path: Line2D
var path_length: float = 0.0
var current_state: State = State.FOLLOW_PATH
var player_position: Vector2
var player_out_of_range_timer: float = 0.0
var return_to_path_delay: float = 3.0

var last_position: Vector2 = Vector2.ZERO
var stuck_timer: float = 0.0
var stuck_threshold: float = 5.0  # Minimum movement to be considered "not stuck"
var stuck_check_time: float = 5.0  # Time to wait before deciding the enemy is stuck
var velocity_threshold: float = 10.0  # Minimum velocity to consider the enemy as moving

func _ready():
	gravity_scale = 0
	var shader_material = load("res://Tax Enemies/enemy_shader.gdshader")
	material = ShaderMaterial.new()
	material.shader = shader_material
	_initialize_path()
	last_position = position

func _initialize_path():
	await get_tree().process_frame
	path = get_tree().root.find_child("Default_Enemy_Path", true, false)
	if path:
		path_length = calculate_path_length()
	else:
		push_error("Default_Enemy_Path not found!")

func calculate_path_length() -> float:
	var length = 0.0
	for i in range(1, path.points.size()):
		length += path.points[i].distance_to(path.points[i-1])
	return length

func _integrate_forces(state):
	if not path:
		return

	player_position = Global_Variables.player_position
	var distance_to_player = position.distance_to(player_position)

	# Stuck detection: Check movement and velocity
	var distance_moved = position.distance_to(last_position)
	var current_velocity = linear_velocity.length()

	# Check if the enemy hasn't moved more than the stuck_threshold and if it has very low velocity
	if distance_moved < stuck_threshold and current_velocity < velocity_threshold:
		stuck_timer += state.step
		if stuck_timer >= stuck_check_time:
			teleport_to_nearest_path_point()
			stuck_timer = 0.0 
	else:
		stuck_timer = 0.0  # Reset the timer if the enemy is moving

	last_position = position  # Update last_position to track movement for the next frame

	match current_state:
		State.FOLLOW_PATH:
			if distance_to_player <= Chase_Distance:
				current_state = State.CHASE_PLAYER
				player_out_of_range_timer = 0.0
			else:
				follow_path(state)

		State.CHASE_PLAYER:
			if distance_to_player > Chase_Distance:
				player_out_of_range_timer += state.step
				if player_out_of_range_timer >= return_to_path_delay:
					current_state = State.RETURN_TO_PATH
			else:
				player_out_of_range_timer = 0.0
				chase_player(state)

		State.RETURN_TO_PATH:
			var closest_path_point = get_closest_point_on_path()
			if position.distance_to(closest_path_point) <= Path_Follow_Distance:
				current_state = State.FOLLOW_PATH
			else:
				return_to_path(state)

	apply_upright_force(state)

func follow_path(state):
	var target_point = get_point_on_path(current_path_offset)
	var direction = (target_point - position).normalized()
	var force = direction * Speed

	current_path_offset += Speed * state.step
	if current_path_offset >= path_length:
		current_path_offset = 0

	apply_central_force(force)

func chase_player(state):
	var direction = (player_position - position).normalized()
	var force = direction * Speed
	apply_central_force(force)

func return_to_path(state):
	var closest_point = get_closest_point_on_path()
	var direction = (closest_point - position).normalized()
	var force = direction * Speed
	apply_central_force(force)

func apply_upright_force(state):
	var current_rotation = state.get_transform().get_rotation()
	var torque = sin(-current_rotation) * Upright_Force
	apply_torque(torque)

func get_closest_point_on_path() -> Vector2:
	if not path:
		return position  # Use `position`

	var closest_point = Vector2.ZERO
	var closest_distance = INF

	for i in range(path.points.size() - 1):
		var segment_start = path.to_global(path.points[i])
		var segment_end = path.to_global(path.points[i + 1])
		var closest_point_on_segment = Geometry2D.get_closest_point_to_segment(position, segment_start, segment_end)
		
		var distance = position.distance_to(closest_point_on_segment)
		if distance < closest_distance:
			closest_distance = distance
			closest_point = closest_point_on_segment

	return closest_point

func get_point_on_path(offset: float) -> Vector2:
	var current_distance = 0.0
	for i in range(1, path.points.size()):
		var segment_length = path.points[i].distance_to(path.points[i-1])
		if current_distance + segment_length > offset:
			var t = (offset - current_distance) / segment_length
			return path.to_global(path.points[i-1].lerp(path.points[i], t))
		current_distance += segment_length
	return path.to_global(path.points[-1])

func teleport_to_nearest_path_point():
	var nearest_point = get_closest_point_on_path()
	position = nearest_point
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	print("Enemy teleported due to being stuck")
