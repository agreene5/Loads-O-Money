# Defines stats and properties of the check shot

extends RigidBody2D

@export var initial_velocity = 150.0
var despawn_timer = Timer.new()

func _ready():
	# Setup the despawn timer
	add_child(despawn_timer)
	despawn_timer.wait_time = 5 
	despawn_timer.one_shot = true  
	despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	despawn_timer.start()
	
	# Disable gravity
	gravity_scale = 0

func set_initial_direction(direction: Vector2):
	# Set the initial velocity based on the direction given
	linear_velocity = direction * initial_velocity

func _on_despawn_timer_timeout():
	queue_free()  # Despawns the coin scene
