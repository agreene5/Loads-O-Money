extends AnimatedSprite2D

func _ready():
	# Start playing the animation
	play()

	# Ensure the animation loops
	set_sprite_frames(sprite_frames)
	sprite_frames.set_animation_loop(animation, true)
