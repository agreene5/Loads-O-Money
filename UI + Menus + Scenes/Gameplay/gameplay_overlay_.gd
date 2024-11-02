extends Control
'''
@onready var animated_sprite = $AnimatedSprite2D
@onready var upgrade_menu_button = $UpgradeMenuButton
@onready var pause_menu = $PauseMenu
@onready var upgrade_menu = $UpgradeMenu

func _ready():
		# Connect to the window resize signal
		get_tree().root.size_changed.connect(_on_window_resize)
		# Initial setup
		_update_positions()

func _on_window_resize():
		_update_positions()

func _update_positions():
		var window_size = get_viewport_rect().size
		
		# For AnimatedSprite2D
		animated_sprite.position = Vector2(
				window_size.x - animated_sprite.get_sprite_frames().get_frame_texture("default", 0).get_width() / 2,
				window_size.y - animated_sprite.get_sprite_frames().get_frame_texture("default", 0).get_height() / 2
		)
		
		# For Control nodes, set their anchors programmatically
		for node in [upgrade_menu_button, pause_menu, upgrade_menu]:
				node.anchor_left = 1
				node.anchor_top = 1
				node.anchor_right = 1
				node.anchor_bottom = 1
				
				# Set the position relative to the anchor (offset)
				node.position = Vector2(-node.size.x, -node.size.y)
'''
