extends Node2D

var original_scale: Vector2
var original_position: Vector2
var original_size: Vector2
var target_size: Vector2
@onready var animation_player = $"../AnimationPlayer"
func _ready():
		original_scale = scale
		original_position = position
		original_size = Vector2(
				ProjectSettings.get_setting("display/window/size/viewport_width"),
				ProjectSettings.get_setting("display/window/size/viewport_height")
		)
		target_size = original_size
		
		get_tree().root.size_changed.connect(_on_window_size_changed)
		_on_window_size_changed()
		await get_tree().create_timer(3.5).timeout
		_fade_in_todd_image()

func _fade_in_todd_image():
		var sprite = $Sprite2D  # Adjust this to match your Sprite2D node's name
		var duration = 2.0
		# Set initial state
		sprite.modulate.a = 0  # Set opacity to 0
		sprite.visible = true
		
		# Create and start the tween
		var tween = create_tween()
		tween.set_parallel(true)  # Allow properties to animate simultaneously
		
		# Animate opacity (modulate.a) from 0 to 1
		tween.tween_property(sprite, "modulate:a", 1.0, duration).set_ease(Tween.EASE_OUT)
		
		# Wait for fade-in to complete, then start rotation
		await tween.finished
		
		# Create new tween for continuous rotation
		var rotation_tween = create_tween()
		rotation_tween.set_loops()  # Make the rotation continuous
		
		# Rotate 360 degrees (2π radians) every 30 seconds
		# Note: rotation is in radians, 2π radians = 360 degrees
		rotation_tween.tween_property(sprite, "rotation", sprite.rotation + TAU, 10.0)
		rotation_tween.tween_property(sprite, "rotation", sprite.rotation, 0)  # Reset for next loop
		


func _on_window_size_changed():
	var window_size = get_viewport().get_visible_rect().size
	
	# Calculate scale factors for both dimensions separately
	var scale_x = window_size.x / original_size.x
	var scale_y = window_size.y / original_size.y
	
	# Apply different scaling for each axis
	scale = Vector2(scale_x, scale_y) * original_scale
	
	# Update position to center the content
	position = original_position * Vector2(scale_x, scale_y)

func _on_exit_pressed() -> void:
	TransitionScene.transition()
	animation_player.play("rick_move_left")
	
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn")
