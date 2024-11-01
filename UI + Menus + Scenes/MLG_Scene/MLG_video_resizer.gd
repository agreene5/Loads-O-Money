extends CanvasLayer

var original_size: Vector2
var base_scale: Vector2 = Vector2(1, 1)  # Default scale

func _ready():
	$VideoStreamPlayer.visible = false
	original_size = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	get_tree().root.size_changed.connect(_on_window_size_changed)
	_on_window_size_changed()
	await get_tree().create_timer(4.0).timeout # Making video invisible for first 4 seconds before beat drops
	$VideoStreamPlayer.visible = true



func _on_window_size_changed():
	var window_size = get_viewport().get_visible_rect().size
	
	# Calculate scale factor
	var scale_factor = min(
		window_size.x / original_size.x,
		window_size.y / original_size.y
	)
	
	# Apply the new scale to the CanvasLayer
	scale = base_scale * scale_factor
	
	# Center the content
	offset = (window_size - original_size * scale_factor) / 2
