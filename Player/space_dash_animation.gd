extends AnimatedSprite2D

var is_dashing = false
var parent_node

func _ready():
		top_level = true
		parent_node = get_parent()

func _physics_process(_delta):
		if is_dashing:
				global_position = parent_node.global_position

func dash_animation():
		visible = true
		is_dashing = true
		$AudioStreamPlayer.play()
		play()
		await get_tree().create_timer(0.6).timeout
		is_dashing = false
		visible = false
