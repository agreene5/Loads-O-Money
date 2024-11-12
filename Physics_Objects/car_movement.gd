extends RigidBody2D

@export var Speed: float = 500
@export var Position_Smoothing: float = 10.0
@export var Rotation_Speed: float = 5.0

var current_path_offset: float = 0.0
var path: Line2D
var path_length: float = 0.0
var target_position: Vector2 = Vector2.ZERO
var next_point_index: int = 1

var car_collision_shape: CollisionShape2D

func _ready():
		gravity_scale = 0
		linear_damp = Position_Smoothing
		car_collision_shape = get_node("Car_Death_Box/CollisionShape2D")
		_initialize_path()
		print("Path follower initialized!")

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
				print("Path completed! Starting over...")
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
