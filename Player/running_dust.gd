extends AnimatedSprite2D

var is_moving := false
var was_moving := false
var parent_node

func _ready():
	top_level = true
	parent_node = get_parent()
	assert(get_parent().has_method("is_moving"), "Parent must have is_moving() method")

func _physics_process(delta):
	is_moving = get_parent().is_moving()
	global_position = parent_node.global_position
	if is_moving and not was_moving:
		# Player just started moving
		visible = true
		play()
	elif not is_moving and was_moving:
		# Player just stopped moving
		queue_stop()
		visible = false
	
	was_moving = is_moving

func queue_stop():
	# Wait for the current animation to finish before stopping
	await animation_finished
	stop()
	
