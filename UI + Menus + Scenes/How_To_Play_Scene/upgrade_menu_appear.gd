extends Sprite2D

# Declare a timer variable
@export var toggle_interval: float = 1.0  # Time between toggles, in seconds

func _ready():
	# Create and configure the timer
	var timer = Timer.new()
	timer.wait_time = toggle_interval
	timer.one_shot = false  # Set to false to repeat the timer
	timer.timeout.connect(_on_timer_timeout) # Connect the timeout signal
	add_child(timer)  # Add the timer as a child of the Sprite2D node
	timer.start()  # Start the timer

# This function will be called every time the timer times out
func _on_timer_timeout():
	visible = not visible  # Toggle the visibility of the sprite
