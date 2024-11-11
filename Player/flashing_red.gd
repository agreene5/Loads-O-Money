extends Node2D

var is_flashing = false
var flash_speed = 1.5  # Flashes per second
var flash_intensity = 0.0
var flash_direction = 1
const MAX_INTENSITY = 0.7  # Maximum red intensity

func _ready():
		# Make sure we process every frame
		set_process(true)

func _process(delta):
		# Get the threshold from Global_Variables
		var threshold = Global_Variables.player_job_values[Global_Variables.player_job][7]
		
		# Check if money is below threshold
		if Global_Variables.money < threshold:
				if not is_flashing:
						is_flashing = true
		else:
				if is_flashing:
						is_flashing = false
						# Reset modulation when we stop flashing
						modulate = Color(1, 1, 1, 1)
		
		# Handle flashing effect
		if is_flashing:
				# Update flash intensity
				flash_intensity += flash_direction * delta * flash_speed
				
				# Change direction when reaching limits
				if flash_intensity >= MAX_INTENSITY:
						flash_intensity = MAX_INTENSITY
						flash_direction = -1
				elif flash_intensity <= 0:
						flash_intensity = 0
						flash_direction = 1
				
				# Apply the red tint
				modulate = Color(
						1,  # Red stays at 1
						1 - flash_intensity,  # Reduce green
						1 - flash_intensity,  # Reduce blue
						1   # Keep full opacity
				)
