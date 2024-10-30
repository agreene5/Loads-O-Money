extends Sprite2D

var rotation_speed: float = (2 * PI) / 10.0  # Full rotation (2π radians) in 15 seconds

func _process(delta: float) -> void:
	# Rotate the sprite
	rotate(rotation_speed * delta)

	# Optional: Reset rotation to 0 when it completes a full circle
	if rotation >= 2 * PI:
		rotation = 0
