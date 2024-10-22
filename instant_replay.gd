extends AnimatedSprite2D

func _ready():
	# Reload all frames for all animations
	for animation in sprite_frames.get_animation_names():
		var frame_count = sprite_frames.get_frame_count(animation)
		for frame in range(frame_count):
			var texture = sprite_frames.get_frame_texture(animation, frame)
			if texture:
				texture.take_over_path(texture.resource_path)

	# Play the animation
	play()
