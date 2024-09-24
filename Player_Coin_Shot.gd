extends RigidBody2D

@export var initial_velocity = 800.0
var deceleration = Global_Variables.deceleration
var despawn_timer = Timer.new()

func _ready():
	# Setup the despawn timer
	add_child(despawn_timer)
	despawn_timer.wait_time = 5 
	despawn_timer.one_shot = true  # Ensure the timer only fires once
	despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	despawn_timer.start()
	
	# Disable gravity
	gravity_scale = 0

func set_initial_direction(direction: Vector2):
	# Set the initial velocity based on the direction given
	linear_velocity = direction * initial_velocity

func _physics_process(delta):
	# Decelerate the bullet at given rate
	var current_speed = linear_velocity.length()
	if current_speed > 0:
		var new_speed = max(0, current_speed - deceleration * delta)
		linear_velocity = linear_velocity.normalized() * new_speed

func _on_despawn_timer_timeout():
	queue_free()  # Despawns the bullet shot scene
