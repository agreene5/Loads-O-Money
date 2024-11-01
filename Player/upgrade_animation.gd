extends AnimatedSprite2D

func upgrade_animation():
	visible = true
	play()
	await get_tree().create_timer(1.4).timeout
	visible = false
