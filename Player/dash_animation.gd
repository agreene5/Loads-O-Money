extends AnimatedSprite2D

func dash_animation():
	visible = true
	$AudioStreamPlayer.play()
	play()
	await get_tree().create_timer(0.6).timeout
	visible = false
