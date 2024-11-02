extends Node2D

var original_scale: Vector2
var original_position: Vector2
var original_size: Vector2

func _ready():
		# Get the AudioStreamPlayer node
		var audio_player = $AudioStreamPlayer
		
		# Pick a random voice line
		var random_voice_line = Global_Variables.bootscreen_voice_lines[randi() % Global_Variables.bootscreen_voice_lines.size()]
		
		# Set and play the audio
		audio_player.stream = load(random_voice_line)
		audio_player.volume_db = -3
		audio_player.play()
		
		# Original window sizing code
		original_scale = scale
		original_position = position
		original_size = Vector2(
				ProjectSettings.get_setting("display/window/size/viewport_width"),
				ProjectSettings.get_setting("display/window/size/viewport_height")
		)
		get_tree().root.size_changed.connect(_on_window_size_changed)
		_on_window_size_changed()
		
		# Create a timer to switch to main menu
		var timer = get_tree().create_timer(6.4)
		timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
		# Load and switch to the main menu scene
		get_tree().change_scene_to_file("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn")

func _on_window_size_changed():
		var window_size = get_viewport().get_visible_rect().size
		
		# Calculate scale factor
		var scale_factor = min(
				window_size.x / original_size.x,
				window_size.y / original_size.y
		)
		
		# Apply the new scale relative to the original scale
		scale = original_scale * scale_factor
		
		# Calculate position offset
		var scaled_offset = (window_size - original_size * scale_factor) / 2
		
		# Apply the new position relative to the original position
		position = original_position * scale_factor + scaled_offset
