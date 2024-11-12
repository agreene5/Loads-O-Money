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
	
	gravity_scale = 0
	linear_damp = 5.0
	
	# Initialize the shader
	var shader_material = load("res://Shaders/Player_Enemy_Shader.gdshader")
	material = ShaderMaterial.new()
	material.shader = shader_material


func _physics_process(delta):
	process_normal_input(delta)
	if Input.is_action_pressed("upgrade"):
		%Menu_Spawner.upgrade_menu()

func process_normal_input(delta):
	velocity = linear_velocity
	var input_vector = get_input_vector()
	
	if input_vector.length() > 0:
		apply_movement(input_vector, delta)
		
		if Input.is_action_pressed("space") and can_boost:
			initiate_boost(input_vector)
			$Dash_Animation.dash_animation()
	
	var target_angle = (get_global_mouse_position() - global_position).angle()
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

func get_input_vector() -> Vector2:
		
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("up"): input_vector.y -= 1
	if Input.is_action_pressed("down"): input_vector.y += 1
	if Input.is_action_pressed("left"): input_vector.x -= 1
	if Input.is_action_pressed("right"): input_vector.x += 1
	return input_vector.normalized() if input_vector.length() > 0 else input_vector


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
	
func level_up():
	$Upgrade_Animation.upgrade_animation()
	await get_tree().create_timer(0.6).timeout
	$Node2D/Player_Sprite.texture = load(Global_Variables.player_job_values[Global_Variables.player_job][6])
	move_speed = 10 * Global_Variables.player_job_values[Global_Variables.player_job][5]
	boost_force = Global_Variables.player_job_values[Global_Variables.player_job][3]
	boost_cooldown = Global_Variables.player_job_values[Global_Variables.player_job][2]

func exp_amount(exp_gained):
	$Exp_Up.visible = true
	$Exp_Up.text = "+%.2f" % exp_gained
	
	# Fade in
	$Exp_Up.modulate.a = 0
	var tween = create_tween()
	tween.tween_property($Exp_Up, "modulate:a", 1.0, 0.5)
	
	# Update position during the entire duration
	var time_elapsed = 0.0
	while time_elapsed < 2.0:
		$Exp_Up.global_position = global_position + Vector2(-40, -80)
		await get_tree().process_frame
		time_elapsed += get_process_delta_time()
		
		# Start fade out in the last second
		if time_elapsed >= 1.5 and $Exp_Up.modulate.a == 1.0:
			tween = create_tween()
			tween.tween_property($Exp_Up, "modulate:a", 0.0, 0.5)
	
	$Exp_Up.visible = false
