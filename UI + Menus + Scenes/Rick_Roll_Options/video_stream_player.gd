extends VideoStreamPlayer

func _ready():
	get_tree().root.size_changed.connect(_on_window_size_changed)
	# Wait for the video to load before initial sizing
	finished.connect(_on_window_size_changed)
	
	# Call _on_window_size_changed immediately to set initial size
	call_deferred("_on_window_size_changed")

func _on_window_size_changed():
	var window_size = get_viewport().get_visible_rect().size
	
	# Set the size to match the window
	custom_minimum_size = window_size
	size = window_size
	
	# Ensure we have a valid video texture
	var video_texture = get_video_texture()
	# Set scale of window
	var scale_factor = min(
		window_size.x / float(video_texture.get_width()),
		window_size.y / float(video_texture.get_height())
	)
	scale = Vector2(scale_factor, scale_factor)
	
	# Center the video in the window
	position = (Vector2(window_size) - (Vector2(video_texture.get_size()) * scale)) / 2


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn")
