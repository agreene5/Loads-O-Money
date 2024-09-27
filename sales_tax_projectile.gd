# This script defines the speed and deceleration of the sales tax bill shot
extends RigidBody2D

var initial_velocity = 350
var despawn_timer = Timer.new()
var deceleration = Global_Variables.deceleration

func _ready():
	# Setup the despawn timer
	add_child(despawn_timer)
	despawn_timer.wait_time = 5 
	despawn_timer.one_shot = true  # Make sure the timer only fires once
	despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	despawn_timer.start()
	# Set initial velocity
	linear_velocity = Vector2(0, initial_velocity)
	# Disable gravity
	gravity_scale = 0

func _physics_process(delta):
	# Decelerate the bullet at given rate
	var current_speed = linear_velocity.length()
	if current_speed > 0:
		var new_speed = max(0, current_speed - deceleration * delta)
		linear_velocity = linear_velocity.normalized() * new_speed

func _on_despawn_timer_timeout():
	queue_free()  # Despawns the bill shot scene

