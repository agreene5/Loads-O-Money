extends AnimatedSprite2D

func _ready():
	visible = true
	play()
	await get_tree().create_timer(0.2).timeout
	visible = false
