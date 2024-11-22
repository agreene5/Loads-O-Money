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
		
		# Create timer but don't await it immediately
		var timer = get_tree().create_timer(90.0)
		timer.timeout.connect(_on_timer_timeout)

func _input(event):
		if event is InputEventMouseButton and event.pressed:
				_change_to_victory_scene()

func _change_to_victory_scene():
		var victory_scene = load("res://UI + Menus + Scenes/Victory_Scene/victory_scene.tscn")
		get_tree().change_scene_to_packed(victory_scene)

func _on_timer_timeout():
		_change_to_victory_scene()

func _on_window_size_changed():
	var window_size = get_viewport().get_visible_rect().size
	var scale_x = window_size.x / original_size.x
	var scale_y = window_size.y / original_size.y
	
	scale = Vector2(scale_x, scale_y) * original_scale
	position = original_position * Vector2(scale_x, scale_y)
