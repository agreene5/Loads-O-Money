extends RigidBody2D

@export var min_y_spawn: float = -47000.0
@export var max_y_spawn: float = 2900.0
@export var left_x_spawn: float = -400.0
@export var right_x_spawn: float = 1500.0

const MIN_SPEED: float = 100.0
const MAX_SPEED: float = 250.0
const MIN_RESET_TIME: float = 13.0
const MAX_RESET_TIME: float = 18.0
const MIN_ANGLE: float = -10.0  # degrees
const MAX_ANGLE: float = 10.0   # degrees

@export var min_rotation_speed: float = 1.0
@export var max_rotation_speed: float = 5.0

var movement_speed: float
var moving_right: bool
var timer: float = 0.0
var rotation_speed: float
var current_reset_time: float

const FADE_DURATION: float = 1.0
var is_fading_out: bool = false
var current_tween: Tween

func _ready():
	angular_damp = 0
	linear_damp = 0
	randomize()
	reset_position_and_movement()

func _physics_process(delta):
	timer += delta
	rotation += rotation_speed * delta
	
	if not is_fading_out and timer >= current_reset_time:
		start_fade_out()

func reset_position_and_movement():
	# Cancel any existing tween
	if current_tween and current_tween.is_valid():
		current_tween.kill()
	
	# Reset state
	is_fading_out = false
	timer = 0.0
	
	# Set new random reset time
	current_reset_time = randf_range(MIN_RESET_TIME, MAX_RESET_TIME)
	
	# Ensure visibility is reset immediately
	modulate = Color(1, 1, 1, 1)
	
	var random_y = randf_range(min_y_spawn, max_y_spawn)
	moving_right = randf() > 0.5
	
	if moving_right:
		position = Vector2(left_x_spawn, random_y)
	else:
		position = Vector2(right_x_spawn, random_y)
	
	movement_speed = randf_range(MIN_SPEED, MAX_SPEED)
	rotation_speed = randf_range(min_rotation_speed, max_rotation_speed)
	if randf() > 0.5:
		rotation_speed = -rotation_speed
	
	# Calculate random angle and convert to radians
	var random_angle_deg = randf_range(MIN_ANGLE, MAX_ANGLE)
	var random_angle_rad = deg_to_rad(random_angle_deg)
	
	# Calculate velocity components using trigonometry
	var velocity_x = movement_speed * cos(random_angle_rad)
	var velocity_y = movement_speed * sin(random_angle_rad)
	
	# Apply direction based on moving right or left
	if moving_right:
		linear_velocity = Vector2(velocity_x, velocity_y)
	else:
		linear_velocity = Vector2(-velocity_x, velocity_y)
	
	angular_velocity = 0

func start_fade_out():
	is_fading_out = true
	
	# Create and start fade timer
	var fade_timer = Timer.new()
	add_child(fade_timer)
	fade_timer.wait_time = FADE_DURATION
	fade_timer.one_shot = true
	fade_timer.connect("timeout", Callable(self, "_on_fade_out_complete"))
	fade_timer.start()
	
	# Store the tween reference
	current_tween = create_tween()
	current_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), FADE_DURATION)

func _on_fade_out_complete():
	reset_position_and_movement()
