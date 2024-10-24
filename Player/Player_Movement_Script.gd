extends RigidBody2D

# Original movement variables
var move_speed = 3000
var rotation_speed = 10.0
var boost_force = 1000
var boost_cooldown = 1.0
var can_boost = true
var velocity = Vector2.ZERO
var pushback_factor = 0.5

# Input recording variables
var recording_enabled = true
var replay_mode = false
var replay_start_time = 0.0
var current_replay_index = 0
var max_replay_time = 5.0 # Store the last 5 seconds
var last_mouse_position = Vector2.ZERO

var is_replaying = false

# Structure for storing input state
class InputState:
	var timestamp: float
	var player_position: Vector2
	var player_rotation: float
	var player_velocity: Vector2
	
	func _init(ts, pos, rot, vel):
		timestamp = ts
		player_position = pos
		player_rotation = rot
		player_velocity = vel

func _ready():
	if not "Player_Stored_Inputs" in Global_Variables:
		Global_Variables.Player_Stored_Inputs = []
	
	gravity_scale = 0
	linear_damp = 5.0
	
	# Initialize the shader
	var shader_material = load("res://Shaders/Player_Enemy_Shader.gdshader")
	material = ShaderMaterial.new()
	material.shader = shader_material


func _physics_process(delta):
	if replay_mode:
		process_replay(delta)
	else:
		process_normal_input(delta)
		record_input(delta)

func process_normal_input(delta):
	velocity = linear_velocity
	var input_vector = get_input_vector()
	
	if input_vector.length() > 0:
		apply_movement(input_vector, delta)
		
		if Input.is_action_pressed("space") and can_boost:
			initiate_boost(input_vector)
	
	var target_angle = (get_global_mouse_position() - global_position).angle()
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

func get_input_vector() -> Vector2:
	if replay_mode: 
		return Vector2.ZERO
		
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("up"): input_vector.y -= 1
	if Input.is_action_pressed("down"): input_vector.y += 1
	if Input.is_action_pressed("left"): input_vector.x -= 1
	if Input.is_action_pressed("right"): input_vector.x += 1
	return input_vector.normalized() if input_vector.length() > 0 else input_vector

func record_input(delta):
	if not recording_enabled or replay_mode:
		return
		
	var current_time = Time.get_ticks_msec() / 1000.0
	var input_state = InputState.new(
		current_time,
		global_position,
		rotation,
		linear_velocity
	)
	
	Global_Variables.Player_Stored_Inputs.append(input_state)
	
	# Remove old inputs (older than 5 seconds)
	while Global_Variables.Player_Stored_Inputs.size() > 0:
		var oldest_input = Global_Variables.Player_Stored_Inputs[0]
		if current_time - oldest_input.timestamp > max_replay_time:
			Global_Variables.Player_Stored_Inputs.pop_front()
		else:
			break

func process_replay(delta):
	if current_replay_index >= Global_Variables.Player_Stored_Inputs.size():
		end_replay()
		return
	
	var input_state = Global_Variables.Player_Stored_Inputs[current_replay_index]
	
	global_position = input_state.player_position
	rotation = input_state.player_rotation
	linear_velocity = input_state.player_velocity
	
	current_replay_index += 1

func start_replay():
	is_replaying = true
	recording_enabled = false
	replay_mode = true
	current_replay_index = 0
	# Set initial replay position
	var oldest_state = Global_Variables.Player_Stored_Inputs[0]
	global_position = oldest_state.player_position
	rotation = oldest_state.player_rotation
	linear_velocity = oldest_state.player_velocity
	

func end_replay():
	is_replaying = false
	replay_mode = false
	recording_enabled = true
	current_replay_index = 0

func apply_movement(input_vector: Vector2, delta: float):
	if replay_mode:
		return
	
	var force = input_vector * move_speed
	apply_central_force(force)

func initiate_boost(boost_direction):
	if can_boost and not replay_mode:
		can_boost = false
		apply_central_impulse(boost_direction * boost_force)
		get_tree().create_timer(boost_cooldown).connect("timeout", Callable(self, "reset_boost"))

func reset_boost():
	can_boost = true
