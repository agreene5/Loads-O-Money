# Defines stats and properties of the check shot

extends RigidBody2D

var initial_velocity = 150.0
var despawn_timer = Timer.new()

func _ready():
	# Play the coin sound effect
	play_check_sound()
	
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

func set_initial_velocity(velocity: Vector2):
	# Add the player's velocity to the initial_velocity
	initial_velocity += velocity.length()

func _on_despawn_timer_timeout():
	queue_free()  # Despawns the coin scene

func play_check_sound():
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		
		audio_player.stream = load("res://Finished_Assets/SFX_Assets/CheckSFX.mp3")
		audio_player.volume_db = -3  # Subtracting 3 decibles because vine boom is loud
		audio_player.set_bus("SFX")
		audio_player.play()
