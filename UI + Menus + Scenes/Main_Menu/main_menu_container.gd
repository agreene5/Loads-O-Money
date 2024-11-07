extends Node2D

var original_scale: Vector2
var original_position: Vector2
var original_size: Vector2

func _ready():
		print("func ready!!!Q")
		# Original window sizing code
		original_scale = scale
		original_position = position
		original_size = Vector2(
				ProjectSettings.get_setting("display/window/size/viewport_width"),
				ProjectSettings.get_setting("display/window/size/viewport_height")
		)
		get_tree().root.size_changed.connect(_on_window_size_changed)
		_on_window_size_changed()

		if Global_Variables.game_just_started:
			_play_bootscreen()
		Global_Variables.game_just_started = false

func _play_bootscreen():
	# Get the AudioStreamPlayer nodes
	var voice_player = $Bootscreen_Voicelines
	var video_audio = $Bootscreen_Vid_SFX
	var color_rect = $ColorRect  # Reference the ColorRect node
	
	# Pick a random voice line from the global list of voice lines
	var random_voice_line = Global_Variables.bootscreen_voice_lines[randi() % Global_Variables.bootscreen_voice_lines.size()]
	
	# Set and play the audio
	voice_player.stream = load(random_voice_line)
	voice_player.volume_db = -3  # Set the volume
	voice_player.play()
	video_audio.play()
	
	# Show and play the video
	$Bootscreen_Vid.visible = true
	color_rect.visible = true
	$Bootscreen_Vid.play()
	
	# Wait for 4 seconds (or until the video finishes)
	await get_tree().create_timer(3.8).timeout
	
	# Stop the video and hide it
	$Bootscreen_Vid.visible = false
	$Bootscreen_Vid.stop()
	
	# Fade out the ColorRect over 1 second (from 100% opacity to 0%)
	var duration = 1.5  # Duration of the fade (1 second)
	var fade_time = 0.0  # Initialize fade time
	
	# Loop to gradually reduce the alpha value over time
	while fade_time < duration:
		fade_time += get_process_delta_time()  # Increment time by the frame time
		var alpha = lerp(1.0, 0.0, fade_time / duration)  # Interpolate alpha from 1 to 0
		color_rect.modulate.a = alpha  # Set the new alpha value on the ColorRect
		await get_tree().process_frame  # Yield to the next frame (corrected)

	# Ensure the final alpha is exactly 0 (fully transparent)
	color_rect.modulate.a = 0.0
	color_rect.visible = false
	
	

func _on_window_size_changed():
	var window_size = get_viewport().get_visible_rect().size
	
	# Calculate scale factors for both dimensions separately
	var scale_x = window_size.x / original_size.x
	var scale_y = window_size.y / original_size.y
	
	# Apply different scaling for each axis
	scale = Vector2(scale_x, scale_y) * original_scale
	
	# Update position to center the content
	position = original_position * Vector2(scale_x, scale_y)
