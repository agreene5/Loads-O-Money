extends Control

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	# Connect to the window resize signal
	get_tree().root.size_changed.connect(_on_window_resize)
	# Initial position setup
	_update_sprite_position()

func _on_window_resize():
	_update_sprite_position()

func _update_sprite_position():
	var window_size = get_viewport_rect().size
	
	# For top-left corner
	animated_sprite.position = Vector2(
		window_size.x - animated_sprite.get_sprite_frames().get_frame_texture("default", 0).get_width() / 2,
		window_size.y - animated_sprite.get_sprite_frames().get_frame_texture("default", 0).get_height() / 2
	)
