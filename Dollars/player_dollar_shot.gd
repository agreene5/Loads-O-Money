extends RigidBody2D

var initial_velocity = 300.0
var amplitude = 500.0  # height of wave
var frequency = 20.0    # number of waves over distance
var despawn_timer: Timer
var elapsed_time = 0.0
var main_dir = Vector2.ZERO  # main direction of dollarshot

func _ready():
	# Play the dollar sound effect
	play_dollar_sound()
	
	# Setup the despawn timer
	despawn_timer = Timer.new()
	add_child(despawn_timer)
	despawn_timer.wait_time = 5 
	despawn_timer.one_shot = true  
	despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	despawn_timer.start()
	
	# Disable gravityW
	gravity_scale = 0

func set_initial_direction(initial_direction: Vector2):
	# main direction normalized and will shoot dollarshot in straight line
	main_dir = initial_direction.normalized()
	
	# linear velocity will move in direction of main direction
	linear_velocity = main_dir * initial_velocity

func set_initial_velocity(velocity: Vector2):
	# Add the player's velocity to the initial_velocity
	initial_velocity += velocity.length()

func _process(delta):
	elapsed_time += delta
	
	# wave offset is calculated to create a constant wave
	var offset = sin(elapsed_time * frequency) * amplitude
	
	# perpendicular direction of wave offset
	var perpendicular_dir = Vector2(-main_dir.y, main_dir.x)
	
	# dollarshot position
	global_position += main_dir * linear_velocity.length() * delta + perpendicular_dir * offset * delta

	# makes dollarshot sprite move along wave
	var final_dir = (main_dir + perpendicular_dir * (offset / amplitude)).normalized()
	rotation = final_dir.angle()

func _on_despawn_timer_timeout():
	queue_free()  # despawn dollarshot
	
func play_dollar_sound():
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		
		audio_player.stream = load("res://Finished_Assets/SFX_Assets/DollarSFX.mp3")
		audio_player.set_bus("SFX")
		audio_player.play()
