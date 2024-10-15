extends RigidBody2D

var move_speed = 3000
var rotation_speed = 10.0  # Speed rotating towards cursor
var boost_force = 1000
var boost_cooldown = 1.0
var can_boost = true

var velocity = Vector2.ZERO


var pushback_factor = 0.5  # Adjust this to control the strength of pushback


func _ready():
	
	
	# Set up properties
	gravity_scale = 0  # Disable gravity
	linear_damp = 5.0  # Reduce damping to allow for more sliding after boost
	
	# Assign the shader material
	var shader_material = load("res://Shaders/Player_Enemy_Shader.gdshader")
	material = ShaderMaterial.new()
	material.shader = shader_material

func _physics_process(delta):
	velocity = linear_velocity
	
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("up"):
		input_vector.y -= 1
	if Input.is_action_pressed("down"):
		input_vector.y += 1
	if Input.is_action_pressed("left"):
		input_vector.x -= 1
	if Input.is_action_pressed("right"):
		input_vector.x += 1
	
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
		
		# Check for boost
		if Input.is_action_pressed("space") and can_boost:
			initiate_boost(input_vector)

	# Rotating towards cursor
	var target_angle = (get_global_mouse_position() - global_position).angle()
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

func initiate_boost(boost_direction):
	if can_boost:
		can_boost = false
		
		# Apply an impulse in the boost direction
		apply_central_impulse(boost_direction * boost_force)
		
		get_tree().create_timer(boost_cooldown).connect("timeout", Callable(self, "reset_boost"))

func reset_boost():
	can_boost = true
