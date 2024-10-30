extends Node2D

var default_camera: Camera2D
var instant_replay_camera: Camera2D
var timer: Timer

func _ready():
	# Get a reference to the default camera
	default_camera = get_viewport().get_camera_2d()
	
	# Get a reference to the instant replay camera
	instant_replay_camera = get_node("Physics_Objects/Car_1/Camera_1")
	
	# Ensure the instant replay camera exists
	if not instant_replay_camera:
		push_error("Instant replay camera not found at path: Physics_Objects/Car_1/Camera_1")
		return
	
	# Create and set up the timer
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 8.0
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func switch_to_instant_replay_camera():
	# Switch to the instant replay camera
	instant_replay_camera.make_current()
	
	# Start the timer
	timer.start()

func _on_timer_timeout():
	# Switch back to the default camera
	default_camera.make_current()
