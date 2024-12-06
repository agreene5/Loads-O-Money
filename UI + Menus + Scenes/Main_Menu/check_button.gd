extends CheckButton

var time_elapsed: float = 0.0
const CYCLE_DURATION: float = 10.0 # Total time for one complete cycle in seconds

func _ready():
	toggled.connect(_on_toggled)
	# Set initial button state based on global variable
	button_pressed = Global_Variables.real_life
	
	# Style the button
	add_theme_color_override("font_color", Color("ffffff"))  # White text
	add_theme_color_override("font_pressed_color", Color("ffffff"))  # White text when pressed
	add_theme_color_override("font_hover_color", Color("cccccc"))  # Light grey on hover
	
	# Style the checkbox/toggle part
	add_theme_color_override("icon_normal_color", Color("666666"))  # Dark grey when unchecked
	add_theme_color_override("icon_pressed_color", Color("3498db"))  # Blue when checked
	add_theme_color_override("icon_hover_color", Color("888888"))  # Medium grey on hover
	
	# Adjust font
	add_theme_font_size_override("font_size", 20)  # Larger text
	
	# Optional: Add some padding
	custom_minimum_size = Vector2(150, 40)  # Adjust size as needed

func _on_toggled(button_pressed):
	if button_pressed:
		print("toggled_on")
		Global_Variables.real_life = true
	else:
		print("toggled_off")
		Global_Variables.real_life = false

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
