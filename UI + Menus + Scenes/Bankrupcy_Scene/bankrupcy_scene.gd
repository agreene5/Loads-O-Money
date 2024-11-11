extends Node2D

var original_scale: Vector2
var original_position: Vector2
var original_size: Vector2

func _ready():
	original_scale = scale
	original_position = position
	original_size = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	get_tree().root.size_changed.connect(_on_window_size_changed)
	_on_window_size_changed()

	get_tree().paused = true
	print("Broke :(")
	await get_tree().create_timer(5.5).timeout # Waiting for sfx to finish
	var gameplay_scene = load("res://UI + Menus + Scenes/Gameplay/gameplay_scene.tscn")
	get_tree().paused = false
	get_tree().change_scene_to_packed(gameplay_scene)

func _on_window_size_changed():
	var window_size = get_viewport().get_visible_rect().size
	
	# Calculate scale factors for both dimensions separately
	var scale_x = window_size.x / original_size.x
	var scale_y = window_size.y / original_size.y
	
	# Apply different scaling for each axis
	scale = Vector2(scale_x, scale_y) * original_scale
	
	# Update position to center the content
	position = original_position * Vector2(scale_x, scale_y)
