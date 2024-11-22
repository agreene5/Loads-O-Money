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
	
	$AnimationPlayer.play("Text_Appear")
	await get_tree().create_timer(1.4).timeout
	ResourceLoader.load_threaded_request("res://UI + Menus + Scenes/Tax_Evasion_Scene/tax_evasion_scene.tscn")
	$AudioStreamPlayer.play()
	await get_tree().create_timer(4.6).timeout
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get("res://UI + Menus + Scenes/Tax_Evasion_Scene/tax_evasion_scene.tscn"))
	queue_free()


func _on_window_size_changed():
	var window_size = get_viewport().get_visible_rect().size
	
	# Calculate scale factors for both dimensions separately
	var scale_x = window_size.x / original_size.x
	var scale_y = window_size.y / original_size.y
	
	# Apply different scaling for each axis
	scale = Vector2(scale_x, scale_y) * original_scale
	
	# Update position to center the content
	position = original_position * Vector2(scale_x, scale_y)
