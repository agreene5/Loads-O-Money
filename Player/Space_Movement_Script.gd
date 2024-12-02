extends RigidBody2D

# Original movement variables
var move_speed = 10 * Global_Variables.player_job_values[Global_Variables.player_job][5]
var rotation_speed = 10.0
var boost_force = Global_Variables.player_job_values[Global_Variables.player_job][3]
var boost_cooldown = Global_Variables.player_job_values[Global_Variables.player_job][2]
var can_boost = true
var velocity = Vector2.ZERO
var pushback_factor = 0.5

# Amount of exp Todd (the player) has
var exp = Global_Variables.player_exp

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
		await get_tree().create_timer(0.1).timeout
		visible = false
		modulate.a = 1
		process_mode = Node.PROCESS_MODE_DISABLED
		gravity_scale = 0
		linear_damp = 0.3
		
		# Initialize the shader
		var shader_material = load("res://Shaders/Player_Enemy_Shader.gdshader")
		material = ShaderMaterial.new()
		material.shader = shader_material

func _physics_process(delta):
		process_normal_input(delta)

func process_normal_input(delta):
		velocity = linear_velocity
		var input_vector = get_input_vector()
		
		# Dash functionality remains
		if Input.is_action_pressed("space") and can_boost:
				if velocity.length() > 0:
						initiate_boost(velocity.normalized())
						$Dash_Animation.rotation = velocity.angle()
				$Dash_Animation.dash_animation()
		
		var target_angle = (get_global_mouse_position() - global_position).angle()
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

func get_input_vector() -> Vector2:
		# Always return zero vector to disable WASD movement
		return Vector2.ZERO

func apply_movement(input_vector: Vector2, delta: float):
		var force = input_vector * move_speed
		apply_central_force(force)

func initiate_boost(boost_direction):
		if can_boost:
				can_boost = false
				apply_central_impulse(boost_direction * boost_force)
				get_tree().create_timer(boost_cooldown).connect("timeout", Callable(self, "reset_boost"))

func reset_boost():
		can_boost = true
