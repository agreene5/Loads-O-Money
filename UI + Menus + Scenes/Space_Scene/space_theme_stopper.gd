extends Area2D

@onready var tween: Tween

func _on_area_entered(area):
		if area.name == "Space_Body_Signaler":
				print("enterededededeededde")
				fade_audio(0.0, 3.0)  # Fade out to volume 0 over 3 seconds

func _on_area_exited(area):
		if area.name == "Space_Body_Signaler":
				print("exiteeedededed")
				fade_audio(1.0, 3.0)  # Fade in to full volume over 3 seconds

func fade_audio(target_volume: float, duration: float):
		# Stop any existing tween
		if tween:
				tween.kill()
		
		# Create a new tween
		tween = create_tween()
		
		# If fading in, start playing the audio immediately
		if target_volume > 0:
				%Space_Theme.volume_db = linear_to_db(0.0001)  # Start from a very low volume
				%Space_Theme.play()
		
		tween.tween_property(%Space_Theme, "volume_db", linear_to_db(target_volume), duration)
		
		# If fading out, stop the audio after the tween completes
		if target_volume == 0:
				tween.tween_callback(%Space_Theme.stop)

func linear_to_db(linear):
		return 20 * log(linear) / log(10) if linear > 0 else -80
