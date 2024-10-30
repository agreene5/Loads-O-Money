extends Camera2D

var default_camera: Camera2D
var timer: Timer

func _ready():
	# Get a reference to the default camera
	default_camera = get_viewport().get_camera_2d()
	
	# Create and set up the timer
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 5.0
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _unhandled_input(event):
	if event.is_action_pressed("switch_camera"):
		switch_to_this_camera()

func switch_to_this_camera():
	# Switch to this camera
	make_current()
	
	# Start the timer
	timer.start()

func _on_timer_timeout():
	# Switch back to the default camera
	default_camera.make_current()
