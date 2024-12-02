extends RigidBody2D

enum State {FLEE_FROM_PLAYER, IDLE_WANDER, FOLLOW_PATH}

@export var Speed: float = 80
@export var Chase_Distance: float = 500
@export var Upright_Force: float = 5.0
@export var Path_Follow_Distance: float = 10.0
@export var Wander_Radius: float = 50.0

var current_path_offset: float = 0.0
var path: Line2D
var path_length: float = 0.0
var current_state: State = State.FOLLOW_PATH
var player_position: Vector2
var flee_timer: float = 0.0
var flee_duration: float = 5.0
var wander_target: Vector2
var wander_timer: float = 0.0
var wander_interval: float = 2.0  # Time between selecting new wander targets
var initial_idle_position: Vector2

# NOT SURE IF NEEDED _-----------------
var player_out_of_range_timer: float = 0.0
var return_to_path_delay: float = 3.0
#-----------------------------------------

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
		initial_idle_position = position
		set_new_wander_target()

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

		# Stuck detection (keep as is)
		var distance_moved = position.distance_to(last_position)
		var current_velocity = linear_velocity.length()
		if distance_moved < stuck_threshold and current_velocity < velocity_threshold:
				stuck_timer += state.step
				if stuck_timer >= stuck_check_time:
						teleport_to_nearest_path_point()
						stuck_timer = 0.0 
		else:
				stuck_timer = 0.0

		last_position = position

		# State management
		match current_state:
				State.FOLLOW_PATH:
						if distance_to_player <= Chase_Distance:
								current_state = State.FLEE_FROM_PLAYER
								flee_timer = 0.0
						else:
								follow_path(state)

				State.FLEE_FROM_PLAYER:
						flee_timer += state.step
						if flee_timer >= flee_duration:
								current_state = State.IDLE_WANDER
								initial_idle_position = position
								set_new_wander_target()
						else:
								flee_from_player(state)

				State.IDLE_WANDER:
						if distance_to_player <= Chase_Distance:
								current_state = State.FLEE_FROM_PLAYER
								flee_timer = 0.0
						else:
								wander_timer += state.step
								if wander_timer >= wander_interval:
										set_new_wander_target()
										wander_timer = 0.0
								idle_wander(state)

		apply_upright_force(state)

func flee_from_player(state):
		var direction = (position - player_position).normalized()  # Reverse direction to flee
		var force = direction * Speed
		apply_central_force(force)

func idle_wander(state):
		var direction = (wander_target - position).normalized()
		var force = direction * (Speed * 0.5)  # Reduced speed for wandering
		apply_central_force(force)

func set_new_wander_target():
		var random_angle = randf() * 2 * PI
		var random_radius = randf() * Wander_Radius
		var offset = Vector2(cos(random_angle), sin(random_angle)) * random_radius
		wander_target = initial_idle_position + offset

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
