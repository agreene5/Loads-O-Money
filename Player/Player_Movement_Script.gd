extends RigidBody2D

var move_speed = 100
var rotation_speed = 10.0  # Speed rotating towards cursor
var boost_force = 50
var boost_cooldown = 0.5
var double_tap_time = 0.2
var can_boost = true
var last_tap = {}

var velocity = Vector2.ZERO

func _ready():
	for action in ["up", "down", "left", "right"]:
		last_tap[action] = 0
	# Set up properties
	gravity_scale = 0  # Disable gravity
	linear_damp = 1.0  # Reduce damping to allow for more sliding after boost
	
	# Assign the shader material
	var shader_material = load("res://Player_Enemy_Shader.gdshader")
	material = ShaderMaterial.new()
	material.shader = shader_material

func _physics_process(delta):
		var current_time = Time.get_ticks_msec() / 1000.0
		
		velocity = linear_velocity
		
		var input_vector = Vector2.ZERO
		if Input.is_action_pressed("up"):
				input_vector.y -= 1
				check_double_tap("up", current_time)
		if Input.is_action_pressed("down"):
				input_vector.y += 1
				check_double_tap("down", current_time)
		if Input.is_action_pressed("left"):
				input_vector.x -= 1
				check_double_tap("left", current_time)
		if Input.is_action_pressed("right"):
				input_vector.x += 1
				check_double_tap("right", current_time)
		
		if input_vector.length() > 0:
				input_vector = input_vector.normalized()
				var force = Vector2.ZERO
				
				# Check if moving opposite to velocity
				if (input_vector.x < 0 and linear_velocity.x > 0) or (input_vector.x > 0 and linear_velocity.x < 0):
						force.x = input_vector.x * move_speed * 4
				else:
						force.x = input_vector.x * move_speed
				
				if (input_vector.y < 0 and linear_velocity.y > 0) or (input_vector.y > 0 and linear_velocity.y < 0):
						force.y = input_vector.y * move_speed * 4
				else:
						force.y = input_vector.y * move_speed
				
				apply_central_force(force)

		# Rotating towards cursor
		var target_angle = (get_global_mouse_position() - global_position).angle()
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

func check_double_tap(action, current_time):
		if Input.is_action_just_pressed(action):
				if current_time - last_tap[action] < double_tap_time:
						initiate_boost(action)
				last_tap[action] = current_time

func initiate_boost(action):
		if can_boost:
				can_boost = false
				var boost_direction = Vector2.ZERO
				match action:
						"up": boost_direction.y = -1
						"down": boost_direction.y = 1
						"left": boost_direction.x = -1
						"right": boost_direction.x = 1
				boost_direction = boost_direction.normalized()
				
				# Apply an impulse in the boost direction
				apply_central_impulse(boost_direction * boost_force)
				
				get_tree().create_timer(boost_cooldown).connect("timeout", Callable(self, "reset_boost"))

func reset_boost():
		can_boost = true
