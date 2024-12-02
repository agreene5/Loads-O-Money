extends RigidBody2D

var speed: float
var rotation_speed: float

func _ready():
	# Set random speed between 150 and 250
	speed = randf_range(150.0, 300.0)
	
	# Set random rotation speed between -3 and 3 rotations per second
	rotation_speed = randf_range(-0.3, 0.3)

func _physics_process(delta):
	if Global_Variables.player_position_space:
		# Get direction to player
		var direction = (Global_Variables.player_position_space - global_position).normalized()
		
		# Apply velocity
		linear_velocity = direction * speed
		
		# Apply rotation
		rotation += rotation_speed * delta * 2.0 * PI
