extends AnimatedSprite2D

var time_elapsed: float = 0.0
const CYCLE_DURATION: float = 10.0 # Total time for one complete cycle in seconds

func _ready():
		play()
		process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
		time_elapsed += delta
		
		# Calculate the position in the cycle
		var cycle_position = fmod(time_elapsed, CYCLE_DURATION) / CYCLE_DURATION
		var angle = cycle_position * TAU # Convert to radians (0 to 2π)
		
		# Calculate RGB values using sine waves
		var red = sin(angle) * 0.5 + 0.5
		var green = sin(angle + TAU/3.0) * 0.5 + 0.5
		var blue = sin(angle + 2.0 * TAU/3.0) * 0.5 + 0.5
		
		# Create and apply the color
		modulate = Color(red, green, blue, 1.0)
