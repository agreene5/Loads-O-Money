extends AnimatedSprite2D

func _ready():
	play()
	# Set parent initially invisible
	get_parent().modulate = Color(1, 1, 1, 0)
	# Create a tween for the delayed fade in
	var tween = create_tween()
	# Wait for 3 seconds
	tween.tween_interval(3.5)
	# Then fade in over 1 second
	tween.tween_property(get_parent(), "modulate", Color(1, 1, 1, 1), 1.0)

func _on_arrow_enter_area_entered(area):
	# Create a tween for fading out
	var tween = create_tween()
	# Modulate the parent node to transparent over 1 second
	tween.tween_property(get_parent(), "modulate", Color(1, 1, 1, 0), 1.0)

func _on_arrow_enter_area_exited(area):
	# Create a tween for fading in
	var tween = create_tween()
	# Modulate the parent node to fully opaque over 1 second
	tween.tween_property(get_parent(), "modulate", Color(1, 1, 1, 1), 1.0)
