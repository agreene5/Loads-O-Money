extends Sprite2D

var rotation_speed: float = 4.0  # Full rotation cycle takes 5 seconds (2 * PI / 5)
var max_rotation: float = deg_to_rad(5.0)  # Convert 5 degrees to radians

func _process(delta: float) -> void:
	# Calculate the new rotation using a sine wave
	var new_rotation = sin(Time.get_ticks_msec() * rotation_speed / 1000.0) * max_rotation
	
	# Apply the new rotation to the sprite
	rotation = new_rotation
