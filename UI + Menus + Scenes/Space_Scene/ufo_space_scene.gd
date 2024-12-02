extends AnimatedSprite2D

var elapsed_time = 0
var movement_duration = 10  # Total duration in seconds
var has_printed = false
var speed = 800  # Units per second
var rotation_speed = 10.0

func _ready():
		play()
		# Make sure the node is ready to process every frame
		process_mode = Node.PROCESS_MODE_INHERIT

func _process(delta):
		rotation_degrees += rotation_speed * delta
		# Update elapsed time
		elapsed_time += delta
		
		# Check if we're still within the movement duration
		if elapsed_time <= movement_duration:
				# Move the sprite right
				position.x += speed * delta
				
				# Check if 3 seconds have passed and we haven't printed yet
				if elapsed_time >= 3.5 and not has_printed:
						%Space_Player.process_mode = Node.PROCESS_MODE_INHERIT
						%Space_Player.linear_velocity = Vector2(50, 0)
						%Space_Player.visible = true
						has_printed = true
