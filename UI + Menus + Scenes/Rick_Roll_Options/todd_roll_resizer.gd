extends Node2D

var original_scale: Vector2
var original_position: Vector2
var video_size: Vector2 = Vector2(260, 120)
var game_size: Vector2

func _ready():
		original_scale = scale
		original_position = position
		game_size = Vector2(
				ProjectSettings.get_setting("display/window/size/viewport_width"),
				ProjectSettings.get_setting("display/window/size/viewport_height")
		)
		
		# Initial scaling to fit game resolution
		var game_scale_x = game_size.x / video_size.x
		var game_scale_y = game_size.y / video_size.y
		scale = Vector2(game_scale_x, game_scale_y)
		
		get_tree().root.size_changed.connect(_on_window_size_changed)
		_on_window_size_changed()



func _on_window_size_changed():
		var window_size = get_viewport().get_visible_rect().size
		
		# Calculate scale factors to fit window
		var window_scale_x = window_size.x / game_size.x
		var window_scale_y = window_size.y / game_size.y
		
		# Calculate final scale (video to game size * game to window size)
		var final_scale_x = (game_size.x / video_size.x) * window_scale_x
		var final_scale_y = (game_size.y / video_size.y) * window_scale_y
		
		# Apply scaling
		scale = Vector2(final_scale_x, final_scale_y)
		
		# Center in window if needed
		position = Vector2(
				(window_size.x - (video_size.x * final_scale_x)) / 2,
				(window_size.y - (video_size.y * final_scale_y)) / 2
		)
