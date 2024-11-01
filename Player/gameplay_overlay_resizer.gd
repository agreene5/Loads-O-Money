extends Control

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	get_tree().root.size_changed.connect(_on_window_resize)
	_update_sprite_position()

func _on_window_resize():
	_update_sprite_position()

func _update_sprite_position():
	var viewport_size = get_viewport_rect().size
	animated_sprite.position = Vector2(viewport_size.x - animated_sprite.offset.x, viewport_size.y - animated_sprite.offset.y)
