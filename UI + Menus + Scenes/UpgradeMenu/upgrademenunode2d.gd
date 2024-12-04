extends Node2D

var original_scale: Vector2
var original_position: Vector2
var original_size: Vector2
var target_size: Vector2

var initial_positions = {}

@onready var animation_player = %AnimationPlayer

func _ready():
		original_scale = scale
		original_position = position
		original_size = Vector2(
				ProjectSettings.get_setting("display/window/size/viewport_width"),
				ProjectSettings.get_setting("display/window/size/viewport_height")
		)
		target_size = original_size
		
		# Store initial animation values
		store_animation_positions("fade_in_upgrade")
		store_animation_positions("fade_out_upgrade")
		
		get_tree().root.size_changed.connect(_on_window_size_changed)
		_on_window_size_changed()

func store_animation_positions(animation_name: String):
		if not animation_player.has_animation(animation_name):
				return
				
		var animation = animation_player.get_animation(animation_name)
		initial_positions[animation_name] = []
		
		for track_idx in animation.get_track_count():
				if animation.track_get_type(track_idx) == Animation.TYPE_VALUE:
						var path = animation.track_get_path(track_idx)
						if path.get_subname(0) == "position":
								var positions = []
								for key_idx in animation.track_get_key_count(track_idx):
										positions.append(animation.track_get_key_value(track_idx, key_idx))
								initial_positions[animation_name].append({
										"track": track_idx,
										"positions": positions
								})

func _on_window_size_changed():
		var window_size = get_viewport().get_visible_rect().size
		
		# Calculate the minimum scale factor to maintain aspect ratio
		var scale_factor = min(
				window_size.x / original_size.x,
				window_size.y / original_size.y
		)
		
		# Update scale
		scale = Vector2(scale_factor, scale_factor) * original_scale
		
		# Center the node in the viewport
		position = (window_size - (original_size * scale)) / 2
		
		# Update animations
		scale_animation("fade_in_upgrade", scale_factor, scale_factor)
		scale_animation("fade_out_upgrade", scale_factor, scale_factor)

func scale_animation(animation_name: String, scale_x: float, scale_y: float):
		if not animation_name in initial_positions:
				return
				
		var animation = animation_player.get_animation(animation_name)
		for track_data in initial_positions[animation_name]:
				var track_idx = track_data["track"]
				var positions = track_data["positions"]
				
				for key_idx in positions.size():
						var initial_value = positions[key_idx]
						if initial_value is Vector2:
								var scaled_value = Vector2(
										initial_value.x * scale_x,
										initial_value.y * scale_y
								)
								animation.track_set_key_value(track_idx, key_idx, scaled_value)

func _on_exit_pressed() -> void:
		get_tree().change_scene_to_file("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn")
