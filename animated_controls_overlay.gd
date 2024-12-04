extends AnimatedSprite2D

func _ready():
		# Make sure the sprite is visible and playing at start
		visible = true
		play()
		
		var wait_timer = get_tree().create_timer(10.0)
		wait_timer.timeout.connect(_on_wait_timer_timeout)

func _on_wait_timer_timeout():
		# Create a tween for the fade out effect
		var tween = create_tween()
		
		# Tween the modulate alpha from 1 to 0 over 2 seconds
		tween.tween_property(self, "modulate:a", 0.0, 2.0)
		
		# Connect to the tween's finished signal to stop the animation
		tween.finished.connect(_on_tween_finished)

func _on_tween_finished():
		# Stop the animation after fade out is complete
		stop()
